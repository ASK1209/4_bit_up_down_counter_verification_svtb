// Code your testbench here
// or browse Examples
interface counter_if(input logic clk);
    logic rst;
    logic enable;
    logic up_down;
    logic [3:0] count;
endinterface
class transaction;
  	logic rst;
    rand bit enable;
    rand bit up_down;
  bit[3:0] count;
endclass
class generator;

    mailbox #(transaction) gen2drv;

  function new(mailbox #(transaction) gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task run();
        transaction tr;

      repeat(2000) begin
            tr = new();
            assert(tr.randomize());
            gen2drv.put(tr);
        end
    endtask

endclass
class driver;

    virtual counter_if vif;
    mailbox #(transaction) gen2drv;

  function new(virtual counter_if vif, mailbox #(transaction) gen2drv);
        this.vif = vif;
        this.gen2drv = gen2drv;
    endfunction

    task run();
        transaction tr;

        forever begin
            gen2drv.get(tr);

            @(negedge vif.clk);
          	//vif.rst = tr.rst;
            vif.enable  <= tr.enable;
            vif.up_down <= tr.up_down;
        end
    endtask

endclass
class monitor;

    virtual counter_if vif;
  	mailbox #(transaction) mon2sb1;
  	function new(virtual counter_if vif, mailbox #(transaction) mon2sb1);
        	this.vif = vif;
        	this.mon2sb1 = mon2sb1;
      		//cg1 = new(vif.enable, vif.up_down, vif.count);
    endfunction

    task run();
      transaction tr;
        forever begin
            @(posedge vif.clk);
            tr = new();
            tr.enable  = vif.enable;
            tr.up_down = vif.up_down;
            tr.rst     = vif.rst;
            tr.count   = vif.count;

          mon2sb1.put(tr);
		  //cg1.sample();

            //mon2sb.put(vif.count);
        end
    endtask
endclass

class scoreboard;
  mailbox #(transaction) mon2sb1;
  bit[3:0] expected;
  function new(mailbox #(transaction) mon2sb1);
        this.mon2sb1 = mon2sb1;
        expected = 0;
  endfunction
  task run();

        transaction tr;//int val;

        forever begin
          mon2sb1.get(tr);
          //Reference model
          if(!tr.rst)
    			begin
      			if(tr.count !== expected)
        			$error("Mismatch! Expected=%0d Got=%0d", expected, tr.count);
                  else
                    $display("PASS Expected=%0d Got=%0d", expected, tr.count);
    			end

    // Update reference model AFTER compare
          if(tr.rst)
        	expected = 0;

          	else if(tr.enable)
    		begin
      			if(tr.up_down)
            		expected = expected + 1;
        		else
            		expected = expected - 1;
    		end
		end
          /*if(tr.rst)
            expected =0;
          else if(tr.enable) begin
            if(tr.up_down) 
              expected = expected + 1;
                else
                    expected = expected - 1;
            end
            // Comparison
            if(tr.count !== expected)
                $error("Mismatch! Expected=%0d Got=%0d", expected, tr.count);
            else
                $display("PASS Expected=%0d Got=%0d", expected, tr.count);
            end*/

    endtask

endclass
module tb;

	logic clk;
//logic rst;

	always #5 clk = ~clk;

	counter_if vif(clk);

	up_down_counter dut(
    	.clk(clk),
    	.rst(vif.rst),
    	.enable(vif.enable),
    	.up_down(vif.up_down),
    	.count(vif.count)
	);
  // Functional Coverage
  	covergroup counter_cg@(posedge clk);

        	cp_enable : coverpoint vif.enable;
        	cp_updown : coverpoint vif.up_down;

        	cp_count : coverpoint vif.count {
            	bins all_states[] = {[0:15]};
              	bins wrap_up   = (15 => 0);
				bins wrap_down = (0 => 15);
        	}

        	cp_cross : cross cp_enable, cp_updown;

    endgroup

  	counter_cg cg1 = new();
  	mailbox #(transaction) gen2drv = new();
  	mailbox #(transaction) mon2sb  = new();
	generator gen;
	driver drv;
	monitor mon;
	scoreboard sb;

	initial begin

    	gen = new(gen2drv);
    	drv = new(vif,gen2drv);
    	mon = new(vif,mon2sb);
    	sb  = new(mon2sb);

    	fork
        	gen.run();
        	drv.run();
        	mon.run();
        	sb.run();
    	join_none

	end

	initial begin
  		$dumpfile("dump.vcd");
  		$dumpvars(0, tb);
    	clk = 0;
    	vif.rst = 1;
    	#20;
    	vif.rst = 0;
  		#5000;
  		$display("Simulation completed");
  		$display("Functional Coverage = %0.2f %%", cg1.get_coverage());
      	$display("Enable coverage    = %0.2f%%",cg1.cp_enable.get_coverage());
		$display("Up/Down coverage   = %0.2f%%",cg1.cp_updown.get_coverage());
      	$display("Count coverage     = %0.2f%%", cg1.cp_count.get_coverage());         			$display("Cross coverage=%0.2f%%" ,cg1.cp_cross.get_coverage());
  		$finish;
	end

endmodule

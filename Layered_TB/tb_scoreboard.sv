
class scoreboard;
  mailbox mon_2_scb_mb;
  int trans_cnt = 0; 

  bit signed [7:0] mem_data_out;
  bit mem_cy;
  transaction trans;

  //constructor
  function new(mailbox mon_2_scb_mb);
    this.mon_2_scb_mb = mon_2_scb_mb;
  endfunction
  
  //-----
  task main;
    bit expected_cy = 1'b0;
    forever begin
      mon_2_scb_mb.get(trans);
      expected_cy = mem_cy; //delaying cy by 1 cycle

      if(trans.acc_ce && (trans.opcode != 4'h1) && (trans.opcode != 4'hF)) begin
        case(trans.opcode)
          //1, 15 : {mem_cy,mem_data_out} = {mem_cy,mem_data_out};
          0 : {mem_cy,mem_data_out} = {1'b0, trans.data_in};
          2 : begin 
                mem_data_out = mem_data_out + trans.data_in;   
                mem_cy = ((( (mem_data_out + trans.data_in) > 127) || ((mem_data_out + trans.data_in) < -128))) ? 1'b1 : 1'b0;
              end
          3 : begin 
                mem_data_out = mem_data_out - trans.data_in;   
                mem_cy = ((( (mem_data_out - trans.data_in) > 127) || ((mem_data_out - trans.data_in) < -128))) ? 1'b1 : 1'b0;
              end
          4 : {mem_cy,mem_data_out} = {1'b0, mem_data_out & trans.data_in};
          5 : {mem_cy,mem_data_out} = {1'b0, mem_data_out | trans.data_in};
          6 : {mem_cy,mem_data_out} = {1'b0, mem_data_out ^ trans.data_in};
          7 : {mem_cy,mem_data_out} = {1'b0, ~mem_data_out};

          default : begin{mem_cy,mem_data_out} = {1'b0, 8'b0}; $error("ALU code unrecognized");end
        endcase
        
      end

      
      if((mem_data_out == trans.data_out) && (expected_cy == trans.cy)) begin
        $display("[SCOREBOARD]: <OK> <data_out: d%0d  (0x%0h) == d%0d  (0x%0h)>,  <cy:  %b == %b> ", mem_data_out,mem_data_out,  trans.data_out,trans.data_out, expected_cy, trans.cy); 
      end else begin
      	$error("[SCOREBOARD] Fail at time: %0.t, data expected: d%0d  (0x%0h), data actual: d%0d  (0x%0h) , cy expected: %b, cy actual: %b ", $time, mem_data_out,mem_data_out,  trans.data_out,trans.data_out, expected_cy, trans.cy);
      end
      
      
      trans_cnt++;
    end
  endtask
  
endclass

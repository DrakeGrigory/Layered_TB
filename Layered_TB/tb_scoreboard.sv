
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

      
      if((mem_data_out != trans.data_out) && (expected_cy != trans.cy)) begin
        $error("tr_%0d @%0.t [SCOREBOARD] FAIL: (exp/rcv) DATA_OUT: %0d (0x%0h) != %0d (0x%0h)    CY: %0b != %0b",trans_cnt,$time, mem_data_out,mem_data_out,  trans.data_out,trans.data_out, expected_cy, trans.cy);
      end else if(mem_data_out != trans.data_out) begin
      	$error("tr_%0d @%0.t [SCOREBOARD] FAIL: (exp/rcv) DATA_OUT: %0d (0x%0h) != %0d (0x%0h)",trans_cnt,$time, mem_data_out,mem_data_out,  trans.data_out,trans.data_out);
      end else if(expected_cy != trans.cy) begin
        $error("tr_%0d @%0.t [SCOREBOARD] FAIL: (exp/rcv)  CY: %0b != %0b",trans_cnt,$time, expected_cy, trans.cy);
      end else begin
        $display("tr_%0d @%0.t [SCOREBOARD] SUCCESS\n",trans_cnt,$time);
      end      
      
      trans_cnt++;
    end
  endtask
  
endclass

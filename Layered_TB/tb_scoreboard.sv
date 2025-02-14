
class scoreboard;
  mailbox mon_2_scb_mb;
  int trans_cnt = 0; 
  int repeat_tests;
  int stats [4] = {0,0,0,0};

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
      

      if(trans.acc_ce) begin
        case(trans.opcode)
          0 : {mem_cy,mem_data_out} = {1'b0, trans.data_in};
          2 : begin 
                mem_cy = ((( (mem_data_out + trans.data_in) > 127) || ((mem_data_out + trans.data_in) < -128))) ? 1'b1 : 1'b0;
                mem_data_out = mem_data_out + trans.data_in;   
              end
          3 : begin 
                //$display("pre_mem_data_out:  %0d   pre_cy:  %0b   trans.data_in: %0d",mem_data_out,mem_cy,trans.data_in);
                mem_cy = ((( (mem_data_out - trans.data_in) > 127) || ((mem_data_out - trans.data_in) < -128))) ? 1'b1 : 1'b0;
                mem_data_out = mem_data_out - trans.data_in;   
                //$display("post_mem_data_out: %0d   oost_cy: %0b     cond1: %0b   cond2: %0b",mem_data_out,mem_cy,((mem_data_out - trans.data_in) > 127),((mem_data_out - trans.data_in) < -128));
              end
          4 : {mem_cy,mem_data_out} = {1'b0, mem_data_out & trans.data_in};
          5 : {mem_cy,mem_data_out} = {1'b0, mem_data_out | trans.data_in};
          6 : {mem_cy,mem_data_out} = {1'b0, mem_data_out ^ trans.data_in};
          7 : {mem_cy,mem_data_out} = {1'b0, ~trans.data_in};
          1,15: {mem_cy,mem_data_out} = {1'b0,8'd0};

          default : begin{mem_cy,mem_data_out} = {1'b0, 8'b0};end
        endcase
        
      end
      expected_cy = mem_cy; //delaying cy by 1 cycle
      
      if((mem_data_out != trans.data_out) && (expected_cy != trans.cy)) begin
        $display("tr_%0d @%0.t [SCOREBOARD] FAIL: (exp/rcv) DATA_OUT: %0d (0x%0h) != %0d (0x%0h)    CY: %0b != %0b\n",trans_cnt,$time, mem_data_out,mem_data_out,  trans.data_out,trans.data_out, expected_cy, trans.cy);
        stats[0]++;
      end else if(mem_data_out != trans.data_out) begin
      	$display("tr_%0d @%0.t [SCOREBOARD] FAIL: (exp/rcv) DATA_OUT: %0d (0x%0h) != %0d (0x%0h)\n",trans_cnt,$time, mem_data_out,mem_data_out,  trans.data_out,trans.data_out);
        stats[1]++;
      end else if(expected_cy != trans.cy) begin
        $display("tr_%0d @%0.t [SCOREBOARD] FAIL: (exp/rcv)  CY: %0b != %0b\n",trans_cnt,$time, expected_cy, trans.cy);
        stats[2]++;
      end else begin
        $display("tr_%0d @%0.t [SCOREBOARD] SUCCESS\n",trans_cnt,$time);
        stats[3]++;
      end      
      
      trans_cnt++;
      if(trans_cnt==repeat_tests) $display("[SCOREBOARD] SCORE: (done/exp) %0d/%0d\nFAIL: Both: %0d;  Data_out: %0d;  Cy: %0b;  \nSUCCESS: %0d",(stats[0]+stats[1]+stats[2]+stats[3]),repeat_tests,stats[0],stats[1],stats[2],stats[3]);
    end
  endtask
  
endclass


class scoreboard;
  mailbox mon_2_scb_mb;
  int trans_cnt = 0; 

  bit [7:0] expected_data_out;
  bit expected_cy;

  //constructor
  function new(mailbox mon_2_scb_mb);
    this.mon_2_scb_mb = mon_2_scb_mb;
  endfunction
  
  //-----
  task main;
    transaction trans;
    bit [7:0] curr_data_out = 8'd0;
    bit curr_cy = 1'b0;
    forever begin
      //prev_data_out = trans.data_out;
      mon_2_scb_mb.get(trans);
      

      if(trans.acc_ce && (trans.opcode != 4'h1) && (trans.opcode != 4'hF)) begin
        
        case(trans.opcode)
          0 :     {curr_cy,curr_data_out} = {1'b0, trans.data_in};
          //1, 15 : {curr_cy,curr_data_out} = {curr_cy,curr_data_out};
          2 :     {curr_cy,curr_data_out} = curr_data_out + trans.data_in;
          3 :     {curr_cy,curr_data_out} = curr_data_out - trans.data_in;
          4 :     {curr_cy,curr_data_out} = {1'b0, curr_data_out & trans.data_in};
          5 :     {curr_cy,curr_data_out} = {1'b0, curr_data_out | trans.data_in};
          6 :     {curr_cy,curr_data_out} = {1'b0, curr_data_out ^ trans.data_in};
          7 :     {curr_cy,curr_data_out} = {1'b0, ~curr_data_out};
          default : begin{curr_cy,curr_data_out} = {1'b0, 8'b0}; $error("ALU code unrecognized");end
        endcase
        
        

      end 
        //putting this above the case, delays scoreboard by 1 iteration
        expected_data_out = curr_data_out;
      	expected_cy = curr_cy;

      
      if((expected_data_out == trans.data_out) && (expected_cy == trans.cy)) begin
        $display("[SCOREBOARD]: <OK> <data_out: %0d == %0d>,  <cy:  %b == %b> ", expected_data_out,  trans.data_out, expected_cy, trans.cy); 
      end else begin
      	$error("[SCOREBOARD] Fail at time: %0.t, data expected: %0d, data actual: %0d , cy expected: %b, cy actual: %b ", $time, expected_data_out,  trans.data_out, expected_cy, trans.cy);
      end
      
      
      trans_cnt++;
    end
  endtask
  
endclass

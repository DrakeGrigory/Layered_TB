program test(DUT_intf intf);
  environment env;
  
  initial 
  begin
    env = new(intf);
    env.gen.repeat_tests = 5;
    env.run();
  end
endprogram

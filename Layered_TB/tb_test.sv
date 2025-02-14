program test(DUT_intf intf);
  environment env;
  
  initial 
  begin
    int repeat_tests =1000;
    env = new(intf);
    env.gen.repeat_tests = repeat_tests;
    env.scb.repeat_tests = repeat_tests;
    env.run();
  end
endprogram

module testtraffic ();
  reg clk, rst_n, sensor;
  wire [2:0] light_h, light_n;
  initial begin
    $monitor ("sensor=%b,light_h=%b,light_n=%b", sensor, light_h, light_n);
    clk = 0;
    rst_n = 1;
    #5  rst_n = 0;
    #15 rst_n = 1;
    #15 sensor = 0;
    // after 20 clock cycles, there is cars in country road, country light should be green, highway should be yellow, then red
    #200 sensor = 1;
    // cars go aways after 5 clock cycles, coutry light should be yellow then red, highway should be green
    #70 sensor = 0;
    
    // then after 10 clock cycles, there is cars in country road, country light should be green, highway should be yellow, then red
    #100 sensor = 1;
    // cars in country are to many, it goes out only after 20 cycles. 
    // however, country should be yellow and then red after 10+2 cycles
    // and highway should goes to green in 10 cycles
    #200 sensor = 0;
    
  end
  always begin
    #5 clk = !clk;
  end 
  
  traffic_controller #(
    .green_timeout(5),
    .yellow_timeout(2)
    )
  traffic(
    .clk(clk),
    .rst_n(rst_n),
    .car_sensor(sensor),
    .highway_light(light_h),
    .country_light(light_n)
  );
endmodule

// Module to control traffic lights in two directions
module traffic_controller(
  clk, // clock
  rst_n, // active low reset
  car_sensor, // =1 if there are cars in country road
  highway_light, // =100, 010, 001 for green, yellow, red
  country_light // =100, 010, 001 for green, yellow, red
  );
  input clk;
  input rst_n;
  input car_sensor;
  output [2:0] highway_light, country_light;
  
  parameter green_timeout = 10; // in green 10 clock cycles
  parameter yellow_timeout = 2; // in yellow 2 clock cycles;

  wire car;
  wire Timeout;
  wire timeout;
  wire start, start_h, start_n;
  wire enable_h, enable_n;
  
  sensor_fsm sensor_control
  (
    // input
    .clk(clk),
    .rst_n(rst_n),
    .sensor(car_sensor),
    // output
    .car(car)
  );
  
  timer_fsm 
  #(
    .green_timeout(green_timeout),
    .yellow_timeout(yellow_timeout)
  ) timer
  (
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    // output
    .Timeout(Timeout),
    .timeout(timeout)
  );
  
  highway_fsm highway_controller
  (
    // input
    .clk(clk),
    .rst_n(rst_n),
    .enable_h(enable_h),
    .car(car),
    .Timeout(Timeout),
    .timeout(timeout),
    // output
    .enable_n(enable_n),
    .light_h(highway_light),
    .start_h(start_h)
  );
  
  country_fsm country_controller
  (
    // input
    .clk(clk),
    .rst_n(rst_n),
    .enable_n(enable_n),
    .car(car),
    .Timeout(Timeout),
    .timeout(timeout),
    // output
    .enable_h(enable_h),
    .light_n(country_light),
    .start_n(start_n)
  );
  
  assign start = start_h | start_n;

endmodule

module sensor_fsm (
  clk,
  rst_n,
  sensor,
  car
  );
  input clk;
  input rst_n;
  input sensor;
  output car;
  
  reg car;
  
  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      car <= 0;
    else
      if (sensor) car <= 1;
      else car <= 0;
  end
endmodule

module timer_fsm(
  clk,
  rst_n,
  start,
  Timeout,
  timeout);
  
  input clk;
  input rst_n;
  input start;
  output Timeout;
  output timeout;
  
  parameter green_timeout = 10;
  parameter yellow_timeout = 2;
  
  reg [3:0] counter;
  
  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      counter <= 1;
    else begin
      if (start) counter <= 1;
      else counter <= counter+1;
    end 
  end
  assign Timeout = (counter == green_timeout);
  assign timeout = (counter == yellow_timeout);
endmodule

module highway_fsm (
  clk,
  rst_n,
  car,
  Timeout,
  timeout,
  enable_h,
  enable_n,
  start_h,
  light_h);
  
  input clk;
  input rst_n;
  input car;
  input Timeout;
  input timeout;
  input enable_h;
  output enable_n;
  output start_h;
  output [2:0] light_h;

  reg enable_n, start_h;
  reg [2:0] NextState, CurrentState;
  
  // Mã hóa tr?ng thái (state encoding)
  localparam  	green_h = 3'b100, 
		           yellow_h = 3'b010, 
             		red_h = 3'b001;	
  // Xây d?ng hàm chuy?n tr?ng thái và hàm ra
  always@ (NextState, CurrentState, enable_h, Timeout, timeout, car) 
  begin
    NextState = CurrentState ;
    start_h = 0; enable_n = 0;
    case (CurrentState)
    green_h: if (car==1 && Timeout == 1)  begin
                NextState = yellow_h; 
                start_h = 1;
             end 
    yellow_h: if (timeout==1) begin
                NextState = red_h;
                enable_n = 1;
		          end
    red_h: if (enable_h) begin
              NextState =green_h; 
              start_h = 1;
	         end 
    endcase
  end 
  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      CurrentState <= green_h;
    else 
      CurrentState <= NextState;
  end
  assign light_h = CurrentState;
endmodule

module country_fsm (
  clk,
  rst_n,
  car,
  Timeout,
  timeout,
  enable_h,
  enable_n,
  start_n,
  light_n);
  
  input clk;
  input rst_n;
  input car;
  input Timeout;
  input timeout;
  output enable_h;
  input enable_n;
  output start_n;
  output [2:0] light_n;
  reg enable_h, start_n;
  
  reg [2:0] NextState, CurrentState;
  
  // Mã hóa tr?ng thái (state encoding)
  localparam  	green_n = 3'b100, 
		           yellow_n = 3'b010, 
             		red_n = 3'b001;	
  // Xây d?ng hàm chuy?n tr?ng thái và hàm ra
  always@ (NextState, CurrentState, enable_n, Timeout, timeout, car) 
  begin
    NextState = CurrentState ;
    start_n = 0; enable_h = 0;
    case (CurrentState)
    green_n: if (car==0 || Timeout == 1)  begin
                NextState = yellow_n; 
                start_n = 1;
             end 
    yellow_n: if (timeout==1) begin
                NextState = red_n;
                enable_h = 1;
		          end
    red_n: if (enable_n==1) begin
              NextState =green_n; 
              start_n = 1;
	         end 
    endcase
  end 
  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      CurrentState <= red_n;
    else 
      CurrentState <= NextState;
  end
  assign light_n = CurrentState;
endmodule
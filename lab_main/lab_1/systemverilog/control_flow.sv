// Nhóm 6
`timescale 1ns/1ps

// 1. Loop
module forever_example;
    initial begin
        forever begin
            #5 $display ("Hello World!"); 
        end
    end
    initial begin
        #50 $finish; 
    end
endmodule

module repeat_example;
    initial begin
        repeat (5) begin
            $display ("Hello World!"); 
        end
    end
endmodule

module while_example;
    bit clk; 
    always #10 clk = ~clk; 
    initial begin
        bit [3:0] counter; 
        counter = 0; 
        $display ("Counter = %0d", counter);
        while (counter < 10) begin
            @(posedge clk); 
            counter++; 
            $display ("Counter = %0d", counter); 
        end

        $display ("Counter = %0d", counter); 
        
        $finish; 
    end
endmodule

module for_example;
    bit clk; 
    always #10 clk = ~clk; 
    initial begin
        bit [3:0] counter; 
        
        $display ("Counter = %0d", counter); 
        for (counter = 2; counter < 14; counter = counter + 2) begin
            @(posedge clk); 
            $display ("Counter = %0d", counter); 
        end

        $display ("Counter = %0d", counter); 
        
        $finish; 
    end
endmodule

module do_while_example;
    bit clk; 

    always #10 clk = ~clk; 
    initial begin
        bit [3:0] counter; 
        counter = 0; 
        $display ("Counter = %0d", counter);

        do begin
            @(posedge clk); 
            counter++; 
            $display ("Counter = %0d", counter); 
        end while (counter < 5); 

        $display ("Counter = %0d", counter); 
        $finish; 
    end
endmodule

module foreach_example;
    bit [7:0] array [0:7];
    initial begin
        foreach (array[index]) begin
            array[index] = index; 
        end

        foreach (array[index]) begin
            $display("array[%0d] = 0x%0h", index, array[index]);
        end
    end
endmodule

// 2. Break, continue
module break_1;
    initial begin
        for (int i = 0; i < 10; i++) begin
            $display("Iteration [%0d]", i);
            if (i == 7) break;
        end
    end
endmodule

module continue_1;
    initial begin
        for (int i = 0; i < 10; i++) begin
            if (i == 7) continue;
            $display("Iteration [%0d]", i);
        end
    end
endmodule

// 3. Blocking and Non-blocking
module blocking;
    reg [7:0] a, b, c, d, e;
    initial begin
        a = 8'hDA;
        $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
        #10 b = 8'hF1;
        $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
        c = 8'h30;
        $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
    end

    initial begin
        #5 d = 8'hAA;
        $display ("[%0t] d=0x%0h e=0x%0h", $time, d, e);
        #5 e = 8'h55;
        $display ("[%0t] d=0x%0h e=0x%0h", $time, d, e);
    end
endmodule

module non_blocking;
    reg [7:0] a, b, c, d, e;
    initial begin
        a <= 8'hDA;
        $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
        #10 b <= 8'hF1;
        $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
        c <= 8'h30;
        $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
    end

    initial begin
        #5 d <= 8'hAA;
        $display ("[%0t] d=0x%0h e=0x%0h", $time, d, e);
        #5 e <= 8'h55;
        $display ("[%0t] d=0x%0h e=0x%0h", $time, d, e);
    end
endmodule

// test blocking
module test_event;
    event e, f;
    initial
        begin
            #10;
            ->e;
            $display("@%0t: Khoi lenh initial 1-Kich hoat blocking event e\n",$time);
        end

    initial
        begin
            #10;
            $display("@%0t: khoi lenh initial 2-doi event e\n",$time);
            @e;
            $display("@%0t: khoi lenh initial 2-bat duoc event e\n",$time);
        end

    initial
        begin
            $display("@%0t: khoi lenh initial 3-doi event e\n",$time);
            @e;
            #10;
            $display("@%0t: khoi lenh initial 3-bat duoc event e\n",$time);
        end

    initial
        begin
            #10;
            ->>f;
            $display("@%0t: Khoi lenh initial 4-Kich hoat non-blocking event f\n",$time);
        end

    initial
        begin
            #10;
            $display("@%0t: khoi lenh initial 5-doi event f\n",$time);
            @f;
            $display("@%0t: khoi lenh initial 5-bat duoc event f\n",$time);
        end

    initial
        begin
            $display("@%0t: khoi lenh initial 6-doi event f\n",$time);
            @f;
            $display("@%0t: khoi lenh initial 6-bat duoc event f\n",$time);
        end

endmodule

// 4. Function and Task
module functions_using_declarations_and_directions;
    initial begin
        int res, s;
        s = sum(5, 9);
        $display("s = %0d", sum(5, 9));
        $display("sum(5,9) = %0d", sum(5, 9));
        $display("mul(3,1) = %0d", mul(3, 1, res));
        $display("res = %0d", res);
    end

    function automatic int sum(input int x, y);
        return x + y;
    endfunction

    function automatic int mul(input int x, y, output int res);
        res = x * y + 1;
        return x * y;
    endfunction

endmodule

// Pass by Value
module functions_passing_arguments_by_value;
    initial begin
        int a, res;
        
        a = $urandom_range(1, 10);

        $display("Before calling fn: a=%0d res=%0d", a, res);
    
        res = fn(a);
        $display("After calling fn: a=%0d res=%0d", a, res);
    end

    function int fn(int a);
        a = a + 5;
        return a * 10;
    endfunction
endmodule

// Pass by Reference
module functions_passing_arguments_by_reference;
    initial begin
        int a, res;
        a = $urandom_range(1, 10);
        $display("Before calling fn: a=%0d res=%0d", a, res);
    
        res = fn(a);
        
        $display("After calling fn: a=%0d res=%0d", a, res);
    end

    function automatic int fn(ref int a);
        a = a + 5;
        return a * 10;
    endfunction
endmodule

//static_task
module static_task;
    initial display();
    initial display();
    initial display();
    initial display();

    task display();
        static integer i = 0;
        i = i + 1;
        $display("i=%0d", i);
    endtask
endmodule

//automatic_task
module automatic_task;

    initial display();
    initial display();
    initial display();
    initial display();

    task automatic display();
        integer i = 0;
        i = i + 1;
        $display("i=%0d", i);
    endtask
endmodule
class MyClass;
    rand int a, b;
    constraint conditional_inside { 
        a inside {[1:5], [10:15]}; // a thuộc từ 1-5 hoặc 10-15
        a > 10 -> b inside {20, 30, 40};
    }
endclass

MyClass obj = new();
if (obj.randomize()) $display("a = %0d, b = %0d", obj.a, obj.b);
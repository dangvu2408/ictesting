module dynamic_array;
    // Create a dynamic array that can hold elements of type int
    int array [];
    initial begin
        // Create a size for the dynamic array -> size here is 5
        // so that it can hold 5 values
        array = new [5];
        // Initialize the array with five values
        array = '{13, 87, 5, 34, 19};
        // Loop through the array and print their values
        foreach (array[i])
        $display ("array[%0d] = %0d", i, array[i]);
    end
endmodule

// Transcript:
// run -all
// # array[0] = 13
// # array[1] = 87
// # array[2] = 5
// # array[3] = 34
// # array[4] = 19
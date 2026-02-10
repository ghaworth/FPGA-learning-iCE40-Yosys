localparam NUM_ROTATIONS = 10;
reg [7:0] rotations [0:9];
initial begin
    rotations[0] = 8'h44;  // L68
    rotations[1] = 8'h1e;  // L30
    rotations[2] = 8'hb0;  // R48
    rotations[3] = 8'h05;  // L5
    rotations[4] = 8'hbc;  // R60
    rotations[5] = 8'h37;  // L55
    rotations[6] = 8'h01;  // L1
    rotations[7] = 8'h63;  // L99
    rotations[8] = 8'h8e;  // R14
    rotations[9] = 8'h52;  // L82
end
module fifo(clk_i,rst_i,wr_en_i,wdata_i,rd_en_i, rdata_o,full_o,empty_o,error_o);
input clk_i, rst_i, wr_en_i, rd_en_i;
parameter WIDTH = 8;
parameter DEPTH = 16;
input [WIDTH-1:0] wdata_i;
output reg [WIDTH-1:0] rdata_o;
reg [4:0] mem [15:0];
output reg full_o, empty_o, error_o;
reg [3:0] wr_ptr, rd_ptr;
reg wr_toggle_f, rd_toggle_f;
integer i;
always@(posedge clk_i)begin
if (rst_i==1) begin
full_o = 0;
empty_o = 1;
error_o = 0;
rdata_o = 0;
wr_ptr = 0;
rd_ptr = 0;
wr_toggle_f = 0;
rd_toggle_f = 0;
for (i=0;i<DEPTH;i=i+1) begin
mem[i] = 0;
end
end
else begin
if (wr_en_i == 1) begin
if (full_o == 1) begin
$display("ERROR : Writing to FIFO");
error_o = 1;
end
else begin
mem[wr_ptr] = wdata_i;
if (wr_ptr == DEPTH-1) begin
wr_toggle_f = ~wr_toggle_f;
wr_ptr = 0;
end
else begin
wr_ptr = wr_ptr+1;

end
end
end

if (rd_en_i == 1) begin
if (empty_o == 1) begin
$display("Error : Reading to FIFO");
error_o = 1;
end
else begin
rdata_o = mem[rd_ptr];
if (rd_ptr == DEPTH-1) begin
rd_toggle_f = ~rd_toggle_f;
rd_ptr = 0;
end
else begin
rd_ptr = rd_ptr + 1;
end
end
end
end
end
// Generating Full and Empty Condition
always @ (wr_ptr or rd_ptr) begin
full_o = 0;
empty_o = 0;
if (wr_ptr == rd_ptr && wr_toggle_f == rd_toggle_f) begin
full_o = 0;
empty_o = 1;
end
if (wr_ptr == rd_ptr && wr_toggle_f != rd_toggle_f) begin
full_o = 1;
empty_o = 0;
end
end
endmodule

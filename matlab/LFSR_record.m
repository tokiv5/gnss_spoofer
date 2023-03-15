reg1 = -1*ones(1, 10);
reg2 = -1*ones(1, 10);
fid=fopen('LFSR.txt','wt');
for i=1:1024
    fprintf(fid, '%d   ', i);
    for j = 10:-1:1
        if reg1(j) == 1
            fprintf(fid, '0');
        else
            fprintf(fid, '1');
        end
    end
    fprintf(fid, '   ');
    for j = 10:-1:1
        if reg2(j) == 1
            fprintf(fid, '0');
        else
            fprintf(fid, '1');
        end
    end
    fprintf(fid, '\n');

    saveBit1     = reg1(3)*reg1(10);
    reg1(2:10)   = reg1(1:9);
    reg1(1)      = saveBit1;

    saveBit2     = reg2(2)*reg2(3)*reg2(6)*reg2(8)*reg2(9)*reg2(10);
    reg2(2:10)   = reg2(1:9);
    reg2(1)      = saveBit2;
end
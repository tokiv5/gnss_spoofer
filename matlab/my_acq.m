settings = initSettings();

[fid, message] = fopen(settings.fileName, 'rb');

caCodesTable = makeCaTable(settings);
samplesPerCode = round(settings.samplingFreq / ...
                           (settings.codeFreqBasis / settings.codeLength));

max_accum = linspace(0, 0, 32);
max_doppler = linspace(0, 0, 32);
max_phase = linspace(0, 0, 32);
second_max_accum = linspace(0, 0, 32);
for d = -20:20
sampleCount = 0;
    for offset = 0 : 1022
        code = 10 * offset + 1;
        i_accum = linspace(0, 0, 32);
        q_accum = linspace(0, 0, 32);
        for sample = 1 : samplesPerCode
            i_in = fread(fid, 1, 'int16');
            q_in = fread(fid, 1, "int16");
            nco_i = sin(2*pi*d*500*sampleCount*(1/10.23e6));
            nco_q = cos(2*pi*d*500*sampleCount*(1/10.23e6));
            for sat = 1 : 32
                i_accum(sat) = caCodesTable(sat, code)*nco_i*i_in + i_accum(sat);
                q_accum(sat) = caCodesTable(sat, code)*nco_q*q_in + q_accum(sat);
            end
            sampleCount = sampleCount + 1;
            if(code == 10230)
                code = 1;
            else
                code = code + 1;
            end
        end
        for sat = 1 : 32 % 1 dopple & 1 code offset complete. Compare with max.
            result = i_accum(sat)*i_accum(sat) + q_accum(sat)*q_accum(sat);
            if(result > max_accum(sat))
                second_max_accum(sat) = max_accum(sat);
                max_accum(sat) = result;
                max_doppler(sat) = d;
                max_phase(sat) = offset;
            end
        end
    end
end
acq_result = linspace(0, 0, 32);
for sat = 1:32
    if(max_accum(sat) / second_max_accum(sat) > 2)
        acq_result(sat) = 1;
    end
end
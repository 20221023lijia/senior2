function N_a1= calculateValues(frame_01, q_ax1)
    frame_0 = cumsum(frame_01);
    frame_1 = zeros(1, length(frame_0)*2-2);
    N_a = zeros(1, length(frame_0));
    j = 2;
    for i = 2:length(frame_0)
        frame_1(j:j+1) = [frame_0(i), frame_0(i)];
        N_a(i) = (q_ax1(j-1) + q_ax1(j)) * frame_01(i) / 2;
        j = j + 2;
    end
    N_a = cumsum(N_a);
    N_a1 = repeatAndTrim(N_a);
end
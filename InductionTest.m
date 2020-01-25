nverts = 1; %Doesn't matter, pick a number
dx = 0.001; %dx for numerical integration
x = -0.5:dx:0.5;
n = 5; %Number of integrals to compute
f = zeros(size(x, 1), n); %Store results of various functions
labels = ['2k = 2'];

for i = 1:size(x, 2)
    f(i, 1) = sawtooth(x(i), nverts) / (nverts/4); %Normalize f
end

for h = 2:n
    for i = 1:size(x, 2)
        temp = 0; %For computing the value of the integral
        for j = 1:size(x, 2)
           temp = temp + (f(j, h-1) * sawtooth(x(i) - x(j), nverts))*dx;
        end
        f(i, h) = temp / (nverts/4); %Normalize f
    end
end

figure(1)
plot(x, f)
title('Integral of product of sawtooths, as a function of final vertex')
legend('2k = 2', '2k = 4', '2k = 6', '2k = 8', '2k = 10'); %Label first 5 curves

function y = sawtooth(x, n)
    y = n * abs(mod((x+0.5), 1) - 0.5);
end
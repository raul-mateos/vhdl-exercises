% check_ma


N_din = 100;
din = 0:N_din-1;

N = 32;

data = zeros(1, (N-1)+N_din);
data(N:end) = din;

ma = zeros(1, N_din);

for i = 1:N_din-1
  buffer = data(i:N+i-1);
  ma(i) = floor(sum(buffer)/N);
end

res = zeros(2, N_din);
res(1, :) = din;
res(2, :) = ma;

% Imprime los 15 primeros valores
res(:, 1:15)


% moving_average


f0 = 50;      % f0 50 Hz
fs = 10000;

T0 = 1/f0;
Ts = 1/fs;

N_cycles = 10;

t = 0:Ts:(N_cycles*T0);

% Generamos la señal ideal:
x = sin(2*pi*f0*t);

% Contaminamos la señal original con ruido:
xn = x + 0.1*randn(size(t));

% Normalizamos las señales:
xn_norm = xn / max(abs(xn));
x_norm = x / max(abs(xn));

%figure;
%subplot(2,1,1);
%plot(t, x_norm);
%
%subplot(2,1,2);
%plot(t, xn_norm);

% Cuantificamos la señal (equivalente a usar un ADC de WL=16 bits):
WL = 16;
FL = WL-1;
signed = true;

q = quantizer('fixed', 'Round', 'Saturate', [WL FL]);
xn_q  = quantize(q, xn_norm);
xn_fp = fi(xn_q, signed, WL, FL);
xn_hw = xn_fp.int;

% Exportar a fichero de texto:
input_file_name = '../questasim/sample_in.txt';
export_txt(input_file_name, xn_hw);

% Importar las muestras de salida desde un fichero de texto:
output_file_name = '../questasim/data_out.txt';
y_hw = import_txt(output_file_name);

figure;
subplot(2,1,1);
plot(t, xn_fp.int);

subplot(2,1,2);
plot(t, y_hw);

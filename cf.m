function [J,Jcrash] = cf(t,u,r,y)

% Prof. Mario Garcia-Sanz 
% Case Western Reserve University (April 2015)

% Fix dimensions
t = t(:);
u = squeeze(u); u = u(:);
r = squeeze(r); r = r(:);
y = squeeze(y); y = y(:);

min_len = min([length(t), length(u), length(r), length(y)]);
t = t(1:min_len);
u = u(1:min_len);
r = r(1:min_len);
y = y(1:min_len);

% t in seconds, r, y in radians, u in volts
ts=0.01;
tinic=15;
tpert=65;
tstep=80;
tparab=95;
tend=120;

beta_n_1=0.02;
beta_n_2=0.7;
beta_n_3=0.18;
beta_n_4=0.08;
beta_n_5=0.00023;
beta_n_6=0.00001;

e=r-y;

count=round(tinic/ts);
j1=0;
while t(count)<tpert
   j1=j1+(t(count)-tinic)*abs(e(count))*ts;
   count=count+1;
end
j2=0;
while t(count)<tstep
   j2=j2+(t(count)-tpert)*abs(e(count))*ts;
   count=count+1;
end
j3=0;
while t(count)<tparab
   j3=j3+(t(count)-tstep)*abs(e(count))*ts;
   count=count+1;
end
j4=0;
while t(count)<tend
   j4=j4+(t(count)-tparab)*abs(e(count))*ts;
   count=count+1;
end

count=round(tinic/ts);
j5=0;
while t(count)<tend
   j5=j5+abs(u(count))*ts;
   count=count+1;
end

count=round(tinic/ts)+1;
j6=0;
while t(count)<tend
   j6=j6+abs(u(count)-u(count-1));
   count=count+1;
end

comp1 = beta_n_1*j1 + beta_n_3*j3 + beta_n_4*j4;
comp2 = beta_n_2*j2;
comp3 = beta_n_5*j5;
comp4 = beta_n_6*j6;

if min(y) < (-28*pi/180)
    Jc = 1.5;
else
    Jc = 0;
end

J      = comp1 + comp2 + comp3 + comp4 + Jc;
Jcrash = Jc;

fprintf('=================== COST FUNCTION RESULTS ===================\n');
fprintf('Tracking component        : %2.5f\n', comp1);
fprintf('Disturbance rejection     : %2.5f\n', comp2);
fprintf('Fuel consumption          : %2.5f\n', comp3);
fprintf('Noise rejection           : %2.5f\n', comp4);
fprintf('Crash penalty             : %2.5f\n', Jc);
fprintf('-------------------------------------------------------------\n');
fprintf('TOTAL COST J              : %2.5f\n', J);
fprintf('=============================================================\n');
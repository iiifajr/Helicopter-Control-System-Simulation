% =========================================================================
% HELICOPTER COMPETITION: CONTROLLER SIMULATION & COST FUNCTION BINDING
%Fajr Aldajani 44456727
% =========================================================================
clear all; 
close all; 
clc;

fprintf('==============================================================\n');
fprintf('        INITIALIZING HELICOPTER SIMULATION ENVIRONMENT        \n');
fprintf('==============================================================\n\n');

%% 1. Plant Parameters
k       = 0.1;        
omega_n = 1.0;  
zeta    = 0.03;    
T       = 0.11;       

%% 2. PID Controller Gains
Kp = 150.0;      
Ki = 0.001;       
Kd = 80.0;       
N  = 200;        

%% 3. Prefilter Parameters
numF = [1];       
denF = [0.1, 1];  

%% 4. Assign Variables to Workspace
simModel = 'helicopter_ver19g'; 

assignin('base', 'k',       k);
assignin('base', 'omega_n', omega_n);
assignin('base', 'zeta',    zeta);
assignin('base', 'T',       T);
assignin('base', 'Kp',      Kp);
assignin('base', 'Ki',      Ki);
assignin('base', 'Kd',      Kd);
assignin('base', 'N',       N);
assignin('base', 'numF',    numF);
assignin('base', 'denF',    denF);

%% 5. Run Simulink Simulation
if exist(simModel, 'file') ~= 4
   error('[ERROR] Simulink model "%s.slx" not found.', simModel);
end

fprintf('Running Simulink model [%s]...\n', simModel);
try
   load_system(simModel);
   set_param(simModel, 'StopFcn', '');
   
   simData = sim(simModel, ...
       'FixedStep',              '0.01', ...
       'StopTime',               '120', ...
       'ReturnWorkspaceOutputs', 'on');
   fprintf('Simulation finished successfully.\n\n');
catch ME
   fprintf('[ERROR] Simulation failed: %s\n', ME.message);
   return;
end

%% 6. Signal Extraction
try
   t = simData.tout; t = t(:);

   try
       u = squeeze(double(simData.u));
       r = squeeze(double(simData.r));
       y = squeeze(double(simData.y));
   catch
       try
           u = squeeze(double(simData.get('u')));
           r = squeeze(double(simData.get('r')));
           y = squeeze(double(simData.get('y')));
       catch
           logsout = simData.logsout;
           u = squeeze(double(logsout.get('u').Values.Data));
           r = squeeze(double(logsout.get('r').Values.Data));
           y = squeeze(double(logsout.get('y').Values.Data));
       end
   end

   u = u(:); r = r(:); y = y(:);

   ts = 0.01;
   n  = length(u);
   t  = (0:n-1)' * ts;

   fprintf('Signal length: %d points (%.1f seconds)\n', n, t(end));

catch ME
   error('[ERROR] Signal extraction failed: %s', ME.message);
end

%% 7. Call Cost Function
fprintf('Evaluating cost function...\n');
if exist('cf', 'file') == 2
   [J_total, J_crash] = cf(t, u, r, y);
else
   fprintf('[WARNING] cf.m not found.\n');
   J_total = Inf; J_crash = 1;
end

%% 8. Plot Results
figure('Name', 'Helicopter Elevation Control', 'NumberTitle', 'off');

subplot(2,1,1);
plot(t, r, 'r--', 'LineWidth', 1.5); hold on;
plot(t, y, 'b-',  'LineWidth', 1.5);
grid on;
xlabel('Time (seconds)');
ylabel('Elevation (radians)');
title('Elevation Angle Tracking');
legend('Reference (r)', 'Actual (y)', 'Location', 'best');

subplot(2,1,2);
plot(t, u, 'g-', 'LineWidth', 1.5);
grid on;
xlabel('Time (seconds)');
ylabel('Control Signal (Volts)');
title('Control Input');
legend('Control (u)', 'Location', 'best');

%% 9. Performance Report
fprintf('==============================================================\n');
fprintf('Simulation Time                : %.2f seconds\n',  t(end));
fprintf('TOTAL COST FUNCTION (J)        : %.5f\n',          J_total);
fprintf('--------------------------------------------------------------\n');
if J_crash > 0
   fprintf('Flight Safety                  : [FAILED] Crashed!\n');
   fprintf('Crash Penalty                  : %.5f\n', J_crash);
else
   fprintf('Flight Safety                  : [PASSED] No crash.\n');
end
fprintf('PID: Kp=%.2f | Ki=%.2f | Kd=%.2f | N=%d\n', Kp, Ki, Kd, N);
fprintf('==============================================================\n\n');
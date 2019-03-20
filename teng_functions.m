clear 
clc 
close all;

Poweravg = zeros(99,1);         %initialisation
Sqarea = zeros(99,1);           %of matrices
DCstamp = zeros(99,1); 

DCmax =0;                       %initialisation
attemps = 0;                    %of values
temp = 20;
duty_cycle = 1;

for i=1:10
    
sim('wo_switch.slx')            %start simulation

Pavg = yout.getElement('pavg'); %get values of Power
tp = Pavg.Values.Time;
Pval = Pavg.Values.Data;

Voltage = yout.getElement('voltage'); %get values of Voltage
tv = Voltage.Values.Time;
Vteng = Voltage.Values.Data;

Charge = yout.getElement('charge');  %get values of Charge
tc = Charge.Values.Time;
Qteng = Charge.Values.Data;

% Nsample = 2048;
% Fsample = 1/Nsample;
% Faxis = -Fsample/2:Fsample/Nsample:Fsample/2-Fsample/Nsample;
% Fpower = fftshift(fft(Pval,Nsample));
% F2I = abs(Fpower).^2;
% 
% IFP = sum(F2I)/5



Square = max(Vteng)*max(Qteng)       %Track the Area of Square VQ
Pavg = max(Pval)          %Calculate the Average Power Paverage


figure                               %Plotting again the selected Area
plot(Qteng,Vteng);
xlabel('Charge Q');
ylabel('Voltage V');
title('Square Area');
axis([0 5.5e-4 -300 300]);

Poweravg(duty_cycle) = Pavg ;   
Sqarea(duty_cycle) = Square ;
DCstamp(duty_cycle) = duty_cycle ;

%%%%%%%%%%%%%%%    using Poweravg or Sqarea
if (duty_cycle-2*temp > 0 )
    if(Poweravg(duty_cycle) < Poweravg(duty_cycle-temp))
        DCmax = duty_cycle;
        duty_cycle = duty_cycle - 2*temp;
        temp =  round(temp/2);
        if (temp == 1)
            break;
        end
    else
        duty_cycle = duty_cycle + temp;
    end
else
    duty_cycle = duty_cycle + temp;
end
    
    if(duty_cycle>99)
         break;
    end
    
end
%%%%%%%%%%%%%%%




stem(DCstamp,Poweravg);             %Drawing plot of Power(Duty_Cycle)
DCmax
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

Square = max(Vteng)*max(Qteng)       %Track the Area of Square VQ
Pavg = 0.707*max(abs(Pval))          %Calculate the Average Power Paverage

% figure                               %Plotting again the selected Area
% plot(Qteng,Vteng);
% xlabel('Charge Q');
% ylabel('Voltage V');
% title('Square Area');


Poweravg(duty_cycle) = Pavg ;   
Sqarea(duty_cycle) = Square ;
DCstamp(duty_cycle) = duty_cycle ;

%%%%%%%%%%%%%%%%    using Poweravg or Sqarea
% if(i>1)
%     if(Poweravg(duty_cycle) < Poweravg(duty_cycle-temp))
%         duty_cycle = duty_cycle - round(temp/2);
%         attemps = attemps +1;
%     elseif (Poweravg(duty_cycle) > Poweravg(duty_cycle-temp) && attemps>1)
%         DCmax = duty_cycle ;
%     else
%         duty_cycle = duty_cycle + temp;
%     end
% end
%%%%%%%%%%%%%%%%
duty_cycle = duty_cycle + temp;

if(duty_cycle>99)
    break
end

end

stem(DCstamp,Poweravg);             %Drawing plot of Power(Duty_Cycle)
DCmax
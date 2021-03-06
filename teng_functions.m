clear 
clc 
close all;

Poweravgteng = zeros(99,1);
Poweravg = zeros(99,1);         %initialisation
Sqarea = zeros(99,1);           %of matrices
DCstamp = zeros(99,1); 

Opt_bs = [ 0 0 0 0 0 ];
Opt_b = [ 0 0 0 0 0];

DCmax =0;                       %initialisation
attemps = 1;                    %of values
temp = 5;
duty_cycle = 1;

for i=1:30
    
sim('final_circuit.slx')            %start simulation

Pavg = yout.getElement('pavg'); %get values of Power
tp = Pavg.Values.Time;
Pval = Pavg.Values.Data;

Pavgt = yout.getElement('Pteng'); %get values of Power
tpt = Pavgt.Values.Time;
Pvalt = Pavgt.Values.Data;

Voltage = yout.getElement('voltage'); %get values of Voltage
tv = Voltage.Values.Time;
Vteng = Voltage.Values.Data;

Charge = yout.getElement('charge1');  %get values of Charge
tc = Charge.Values.Time;
Qteng = Charge.Values.Data;


Square = max(Vteng)*max(Qteng)  ;     %Track the Area of Square VQ
Pavg = max(Pval)          %Calculate the Average Power Paverage
Pavgteng = max(Pvalt);


% figure                               %Plotting again the selected Area
% plot(Qteng,Vteng);
% xlabel('Charge Q');
% ylabel('Voltage V');
% title('Square Area');
% axis([0 5.5e-4 -300 300]);

Poweravgteng(duty_cycle) = Pavgteng;
Poweravg(duty_cycle) = Pavg ;   
Sqarea(duty_cycle) = Square ;
DCstamp(duty_cycle) = duty_cycle ;

%%%%%%%%%%%%%%%    using Poweravg or Sqarea

if (duty_cycle-2*temp > 0 && duty_cycle < 99)
    
        if(DCstamp(duty_cycle-temp)~=0)             %% find the last used duty cycle to compare with the new one
            lu_dc = duty_cycle-temp;
        elseif(DCstamp(duty_cycle-temp*2)~=0)
            lu_dc = duty_cycle-temp*2;
        else
            lu_dc = duty_cycle-temp*2-1;
        end
    
    if(Poweravg(duty_cycle) < Poweravg(lu_dc))          %% compare the two duty cycles
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
       attemps = attemps +1;
end
%%%%%%%%%%%%%%%

stem(DCstamp,Poweravg);             %Drawing plot of Power(Duty_Cycle)
duty_cycle+2
bs = Poweravgteng(duty_cycle+2)
attemps


for Vc_bat = 30:20:110
    
sim('wo_buckswitch.slx')            %start simulation for circuit without buck and switch

bPavg = yout.getElement('Pteng'); %get values of Power
btp = bPavg.Values.Time;
bPval = bPavg.Values.Data;

bVoltage = yout.getElement('voltage1'); %get values of Voltage
btv = bVoltage.Values.Time;
bVteng = bVoltage.Values.Data;

bCharge = yout.getElement('charge1');  %get values of Charge
btc = bCharge.Values.Time;
bQteng = bCharge.Values.Data;

bPavg = max(bPval)     ;     %Calculate the Average Power Paverage



sim('wo_buck.slx')            %start simulation for circuit without buck

sPavg = yout.getElement('Pteng'); %get values of Power
stp = sPavg.Values.Time;
sPval = sPavg.Values.Data;

sVoltage = yout.getElement('voltage'); %get values of Voltage
stv = sVoltage.Values.Time;
sVteng = sVoltage.Values.Data;

sCharge = yout.getElement('charge1');  %get values of Charge
stc = sCharge.Values.Time;
sQteng = sCharge.Values.Data;

sPavg = max(sPval)     ;     %Calculate the Average Power Paverage


Difference_no_buck_no_switch = bs - bPavg   % find the differences
Difference_no_buck = bs - sPavg

Optimization_Percentage_without_buckswitch = ( bs/bPavg - 1 )*100
Optimization_Percentage_without_buck = ( bs/sPavg - 1)*100

Opt_bs((Vc_bat-30)/20 + 1) = Optimization_Percentage_without_buckswitch;
Opt_b((Vc_bat-30)/20 + 1) = Optimization_Percentage_without_buck;


end


f = figure;
uit = uitable(f);

d = {Opt_bs(1),Opt_b(1);Opt_bs(2),Opt_b(2);Opt_bs(3),Opt_b(3);Opt_bs(4),Opt_b(4);Opt_bs(5),Opt_b(5)};
uit.Data = d;
uit.Position = [20 20 363 112];

uit.ColumnName = {'  Optimization of Buck and Switch  ','  Optimization of Buck  '};
uit.RowName = {30,50,70,90,110};

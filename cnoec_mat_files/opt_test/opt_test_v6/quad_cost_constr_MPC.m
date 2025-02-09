function [f,h] = quad_cost_constr_MPC(x,Ts,Np,th)
%% Build vector of inputs
 
t_in        =   [0:Ts:(Np-1)*Ts]';
z0         =   [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0]; %15 stati
u_in        =   [x(1:Np,1)';x(Np+1:end,1)]; %Thrust_force_speed and progession_speed as input
d_in =[0;0;0];
assignin('base','z0',z0);
assignin('base','t_in',t_in);
assignin('base','u_in',u_in);

%% Run simulation with FFD
time_FFD    =   [0:0.01:(Np-1)*Ts];
Nblock      =   Ts/0.01;
Nsim_FFD    =   length(time_FFD);

z_sim      =   zeros(15,Nsim_FFD);
z_sim(:,1) =   z0;
for ind=2:Nsim_FFD
    u                   =   u_in(:,1+floor(time_FFD(ind)/Ts));
    d                   =   d_in(:,1+floor(time_FFD(ind)/Ts));
    zdot               =   quad_augmented(0,z_sim(:,ind-1),u,d,th);
    z_sim(:,ind)       =   z_sim(:,ind-1)+Ts/Nblock*zdot;
end

X_sim       =   z_sim(1,1:Nblock:end)';
Y_sim       =   z_sim(2,1:Nblock:end)';
Z_sim       =   z_sim(3,1:Nblock:end)';

X_dot_sim       =   z_sim(4,1:Nblock:end)';
Y_dot_sim       =   z_sim(5,1:Nblock:end)';
Z_dot_sim       =   z_sim(6,1:Nblock:end)';

psi_sim       =   z_sim(7,1:Nblock:end)';
theta_sim       =   z_sim(8,1:Nblock:end)';
phi_sim       =   z_sim(9,1:Nblock:end)';

p_sim       =   z_sim(10,1:Nblock:end)';
q_sim       =   z_sim(11,1:Nblock:end)';
r_sim       =   z_sim(12,1:Nblock:end)';

%augmented states
progress_sim =       z_sim(13,1:Nblock:end); % to define the position of the quadcopter w.r.t the trajectory
progress_speed_sim = z_sim(14,1:Nblock:end); 
thrust_forces_sim   = z_sim(15,1:Nblock:end);

%% for cycle for the  prediction

%% compute the el error (projection of e(theta_k) w.r.t. the tangent)
f1  = 
%% compute the contour error

e_c_y = (y_des-Y_sim)'*(y_des-Y_sim);
e_c_x = (x_des - X_sim)'*(x_des - X_sim);
f2  = e_c_x + e_c_y;

speed = zeros(N_points,1);
Time = zeros(N_poinlts,1);

for ind = 1 : N_points
speed(ind) = sqrt((X_dot_sim(ind))^2+ (Y_dot_sim(ind))^2);
Time(ind) = abs(distance(ind) / speed(ind));
end
%{
%% Compute path constraints h(x)
h           =   [Y_sim-(tanh((X_sim-100)/2e1)*10+5);
                -Y_sim+(tanh((X_sim-75)/2e1)*10+15)];
%}

%% compute h constraints
% acceleration initial version are linear ones so we don't consider now the
%  non linear ones
h = [];
%% Compute cost function f(x)
Thrust_force_diff  =   (x(4:end,1)-x(3:end-1,1));
%Td_diff     =   (x(5:Np+3,1)-x(4:Np+2,1));
f1 = 1e3*(Thrust_force_diff'*Thrust_force_diff); %to have a not so high Thrust force between 2 steps
f2 = sum(Time);
f = -f1 +f2;
%f           =   -X_sim(end,1)+1e3*z_sim(5,end)^2+1e3*(Thrust_force_diff'*Thrust_force_diff)+1e-2*(Td_diff'*Td_diff);

%% Stack cost and constraints
v           =   [f;h];
end
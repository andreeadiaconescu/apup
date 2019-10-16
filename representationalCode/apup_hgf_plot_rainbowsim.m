function apup_hgf_plot_rainbowsim(iSubject,apup_plot,colors)
currCol = colors(iSubject,:);
% Set up display
scrsz = get(0,'screenSize');
outerpos = [0.2*scrsz(3),0.2*scrsz(4),0.8*scrsz(3),0.8*scrsz(4)];

% set(gcf,'DefaultAxesColorOrder',colors);
sh(1) = subplot(3,1,1);
sh(2) = subplot(3,1,2);
sh(3) = subplot(3,1,3);
% Number of trials
nTrials = size(apup_plot.u,1)-1;


% Subplots
axes(sh(1))
plot(0:nTrials, [apup_plot.p_prc.mu_0(3); apup_plot.traj.mu(1:nTrials,3)], 'Color', currCol, 'LineWidth', 2);
hold on;
plot(0, apup_plot.p_prc.mu_0(3), 'o','Color', currCol,  'LineWidth', 2); % prior
xlim([0 nTrials]);
title('Posterior expectation \mu_3 of log-volatility of tendency x_3', 'FontWeight', 'bold');
xlabel('Trial number');
ylabel('\mu_3');

axes(sh(2));
plot(0:nTrials, [apup_plot.p_prc.mu_0(2); apup_plot.traj.mu(1:nTrials,2)], 'Color', currCol, 'LineWidth', 2);
hold on;
plot(0, apup_plot.p_prc.mu_0(2), 'o', 'Color', currCol,  'LineWidth', 2); % prior
xlim([0 nTrials]);
title('Posterior expectation \mu_2 of tendency x_2', 'FontWeight', 'bold');
xlabel({'Trial number', ' '}); % A hack to get the relative subplot sizes right
ylabel('\mu_2');
% hold off;

axes(sh(3));
plot(0:nTrials, [sgm(apup_plot.p_prc.mu_0(2), 1); sgm(apup_plot.traj.mu(1:nTrials,2), 1)],'Color', currCol, 'LineWidth', 2);
hold on;
plot(0, sgm(apup_plot.p_prc.mu_0(2), 1), 'o', 'Color', currCol,  'LineWidth', 2); % prior
plot(1:nTrials, apup_plot.u(1:nTrials,1), 'o', 'Color', [0 0.6 0]); % inputs
if ~isempty(find(strcmp(fieldnames(apup_plot),'y'))) && ~isempty(apup_plot.y)
    y = stretch(apup_plot.y(1:nTrials,1), 1+0.16 + (iSubject-1)*0.05);
    plot(1:nTrials, y, '.', 'Color', currCol); % responses
    title(['Input u (green), responses (rainbow) and posterior expectation of input s(\mu_2) for \omega_2=', num2str(apup_plot.p_prc.om(2)), ...
        ', \omega_3=', num2str(apup_plot.p_prc.th)],'FontWeight', 'bold');
    
    ylabel('y, u, s(\mu_2)');
    axis([0 nTrials -0.35 1.35]);
else
    title(['Input u (green) and posterior expectation of input s(\mu_2) (red) for \kappa=', ...
        num2str(apup_plot.p_prc.ka), ', \omega_2=', num2str(apup_plot.p_prc.om(2)), ', \omega_3=', num2str(apup_plot.p_prc.th)], ...
        'FontWeight', 'bold');
    ylabel('u, s(\mu_2)');
    axis([0 nTrials -0.1 1.1]);
end
plot(1:nTrials, 0.5, 'k');
xlabel('Trial number');
hold on;
end


function y = stretch(y, fac)
y = y - 0.5;
y = y*fac;
y = y + 0.5;
end


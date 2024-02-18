function mnket_create_designs( id )

global OPTIONS

details = mnket_subjects(id);

load(details.simFilePost);

switch OPTIONS.stats.design
    case 'epsilon'
        design.epsilon2 = sim.reg.bayesian;
        design.epsilon3 = sim.reg.epsi3;
        
    case 'plustime'
        design.epsilon2 = sim.reg.bayesian;
        design.epsilon3 = sim.reg.epsi3;
        design.time = [1: length(design.epsilon3)]';
        
    case 'HGF'
        design.delta1 = sim.reg.delta1;
        design.sigma2 = sim.reg.sigma2;
        design.delta2 = sim.reg.delta2;
        design.sigma3 = sim.reg.sigma3;
    
    %{    
    case 'epsilonS'
        design.transPE = sim.reg.repetition;
        design.repetPE = sim.reg.bayesian;
        design.epsilon3 = sim.reg.epsi3;
    %}
        
    case 'shannon'
        design.epsilon2 = sim.reg.bayesian;
        design.epsilon3 = sim.reg.epsi3;
        design.shannon = sim.reg.shannon;
        
end

save(details.design, 'design');

end


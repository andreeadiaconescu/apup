function [iCombPercResp] = apup_get_model_space

iCombPercResp = zeros(6,2);
iCombPercResp([1:3],1) = 1:3;
iCombPercResp(4,1) = 3;
iCombPercResp([5 6],1) = 4;

iCombPercResp(1:3,2) = 1;
iCombPercResp(4,2) = 2;
iCombPercResp(5,2) = 1;
iCombPercResp(6,2) = 2;
end
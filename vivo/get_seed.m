function seed = get_seed(seedmask,data,wholemask)

seed = [0,0,0];
while ~any(seed~=0)
    index = round(size(seedmask,1)*rand());
    if index<=size(seedmask,1) && index~=0
        seed = seedmask(index,:)+[rand(),rand(),rand()]-[0.5,0.5,0.5];
    end
end

end
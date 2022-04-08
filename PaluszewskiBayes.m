f=1;
t=2;

pB(t) = 0.3;
pB(f) = 1-pB(t);

pW(t) = 0.007;
pW(f) = 1-pW(t);

pSW(t,t) = 0.15;
pSW(t,f) = 0.07;
pSW(f,t) = 1-pSW(t,t);
pSW(f,f) = 1-pSW(t,f);

pGS(t,t) = 0.08;
pGS(t,f) = 0.03;
pGS(f,t) = 1-pGS(t,t);
pGS(f,f) = 1-pGS(t,f);

pZBS(t,t,t) = 0.8;
pZBS(t,f,t) = 0.55;
pZBS(t,t,f) = 0.7;
pZBS(t,f,f) = 0.15;


pZBS(f,t,t) = 1-pZBS(t,t,t);
pZBS(f,f,t) = 1-pZBS(t,f,t);
pZBS(f,t,f) = 1-pZBS(t,t,f);
pZBS(f,f,f) = 1-pZBS(t,f,f);

pUZ(t,t) = 0.1;
pUZ(t,f) = 0.025;
pUZ(f,t) = 1-pUZ(t,t);
pUZ(f,f) = 1-pUZ(t,f);

%1 - wyznaczanie lacznego rozkladu prawdopodob.



for b = 1:2
    for g = 1:2
        for s = 1:2
            for u = 1:2
                for w = 1:2
                    for z = 1:2
                        rozkladPrawdopodob(b,g,s,u,w,z) = pB(b) * pW(w) * pSW(s,w) * pGS(g,s) * pZBS(z,b,s) * pUZ(u,z);
                    end
                end
            end
        end
    end
end


    disp(sum(sum(sum(sum(sum(sum(sum(rozkladPrawdopodob)))))))); % sprawdzenie, czy prawdopodobienstwa sumuja sie do 1.

%2 - metoda analityczna

%prawdob. p(W,G)

pWandG = 0;
for b = 1:2
    for s = 1:2
        for u = 1:2
            for z = 1:2
                pWandG = pWandG + rozkladPrawdopodob(b,t,s,u,t,z);
            end
        end
    end
end

%prawdob. p(G)
pG = 0;
for b = 1:2
    for s = 1:2
        for u = 1:2
            for w = 1:2
                for z = 1:2
                    pG = pG + rozkladPrawdopodob(b,t,s,u,w,z);
                end
            end
        end
    end
end

pWG = pWandG/pG;

%prawdob. p(U,~B)
pUandnotB = 0;

for g = 1:2
    for s = 1:2
        for w = 1:2
            for z = 1:2
                pUandnotB = pUandnotB + rozkladPrawdopodob(f,g,s,t,w,z);
            end
        end
    end
end

%prawdob. p(~B)
pnotB = 0;
for g = 1:2
    for s = 1:2
        for u = 1:2
            for w = 1:2
                for z = 1:2
                    pnotB = pnotB + rozkladPrawdopodob(f,g,s,u,w,z);
                end
            end
        end
    end
end

pUnotB = pUandnotB/pnotB;

disp(pWG);
disp(pUnotB);

%4 - Monte Carlo

hold on
obiegi = 10000;


for i=1: 5000
    plot ([1 5000], [pWG pWG]); % Analityczne p(W|G) - wykres funkcji stałej
    
    w = rand(1,obiegi) < pW(t);
    
    
    sw = rand(1,obiegi) < pSW(t,t);
    snotw = rand(1,obiegi) < pSW(t,f);
    
    s = (sw&w)|(snotw&~w);
    
    gs = rand(1,obiegi) < pGS(t,t);
    gnots = rand(1,obiegi) < pGS(t,f);
    
    g = (gs&s)|(gnots&~s);
    
    res = sum(w&g)/sum(g);
    
    if i == 1
        sr(i) = res;
    else
        sr(i) = sr(i-1) + (res - sr(i-1))/i;
    end
    
  
    
end
 
disp(length(sr));
plot(1:5000, sr);
hold off
figure;

hold on


for i=1:5000
    plot ([1 5000], [pUnotB pUnotB]); % Analityczne p(U|~B) - wykres funkcji stałej
    
    b = rand(1,obiegi) < pB(t);
    
     sw = rand(1,obiegi) < pSW(t,t);
    snotw = rand(1,obiegi) < pSW(t,f);
    
    s = (sw&w)|(snotw&~w);
    
    zbs = rand(1,obiegi) < pZBS(t,t,t);
    znotbs = rand(1,obiegi) < pZBS(t,f,t);
    zbnots = rand(1,obiegi) < pZBS(t,t,f);
    znotbnots = rand(1,obiegi) < pZBS(t,f,f);
    
    z = (zbs&b&s)|(znotbs&~b&s)|(zbnots&b&~s)|(znotbnots&~b&~s);
    
    uz = rand(1,obiegi) < pUZ(t,t);
    unotz = rand(1,obiegi) < pUZ(t,f);
    
    u = (uz&z)|(unotz&~z);
    
    result = sum(u&~b)/sum(~b);
    
    
    if i == 1
        sr2(i) = result;
    else
        sr2(i) = sr2(i-1) + (result - sr2(i-1))/i;
    end
    
    
end
plot(1:5000, sr2);

hold off



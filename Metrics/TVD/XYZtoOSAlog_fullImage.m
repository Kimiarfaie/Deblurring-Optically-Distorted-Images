function [Losa,LE,GE,JE]=XYZtoOSAlog_fullImage(x,y,z,YY)
% entra il fattore di luminanza Y, indicato con YY, e la cromaticità x,y
% esce   la chiarezza LE e le coordinate GE e JE, indicate con g e j
% =====================================dati==========
% ..................................PARAMETRI DA JOSA A 2006
warning off
SINalfa = -0.1792; COSalfa = 0.9837;
SINbeta = 0.9482;  COSbeta = 0.3175;
AsuBn = 0.9366; BsuCn = 0.9807;
% ..................................PARAMETRI da COM W come in JOSA A in stampa (ottobre 2008)
aL = 2.89;  bL = 0.015;
aC = 1.256; bC = 0.05;
% ..................................OSA Lightness coefficients
fx2 = 4.4934; fy2 = 4.3034; fxy = -4.276; fx = -1.3744; fy = -2.5643; f0 = 1.8103;
% =================================================
    
    
    % Lighthness and scale factors Sg Sj
    u3 = 1/3;
    EFFE = fx2 .* x .^ 2 + fy2 .* y .^ 2 + fxy .* x .* y + fx .* x + fy .* y + f0;
    YY0 = YY .* EFFE;
    Y30 = abs(YY0 - 30);
    Y30 = Y30 .^ u3;
    Y30(YY0 < 30) = -Y30(YY0<30);
           
    ELLE = 5.9 .* (YY0 .^ u3 - 2 ./ 3 + 0.042 .* (Y30));
    Losa = (ELLE - 14.4) ./ sqrt(2);
    clear ELLE EFFE YYO Y30
    Sg = -2 .* (0.7640 .* Losa + 9.2521);
    Sj = 2 .* (0.5735 .* Losa + 7.0892);
    % ______________________________ABC PRIMARIES_____________________________
    A = 0.6597 .* x + 0.4492 .* y - 0.1089 .* z;
    B = -0.3053 .* x + 1.2126 .* y + 0.0927 .* z;
    C = -0.0374 .* x + 0.4795 .* y + 0.5579 .* z;
    % _____________________________ g j COORDINATES___________________________
    g = 10 .* Sg .* (SINbeta .* log((A ./ B) ./ AsuBn) - COSbeta .* log((B ./ C) ./ BsuCn));
    j = 10 .* Sj .* (-SINalfa .* log((A ./ B) ./ AsuBn) + COSalfa .* log((B ./ C) ./ BsuCn));

    g(isnan(g)) = 0;
    j(isnan(j)) = 0;  

    CROMA0 = sqrt(g .^ 2 + j .^ 2);
    % -------------------------------------------croma log compressa                        
    cr = log(1 + (bC ./ aC) .* CROMA0) ./ bC;
    cr(isnan(cr)) = 0;

    hue = g./j;
    hue(isnan(hue)) = 0;

    ss = size(g);
    SEGNOg=  ones(ss(1), ss(2)); 
    SEGNOg(g<0) = -1;

    ss = size(j);
    SEGNOj=  ones(ss(1), ss(2)); 
        SEGNOj(j<0) = -1;


    TGh2 = hue .^ 2;
    SENh2 = TGh2 ./ (1 + TGh2);
    COSh = sqrt(1 - SENh2);
    SENh = sqrt(SENh2);

    g = cr .* SENh .* SEGNOg;
    j = cr .* COSh .* SEGNOj;
    % -------------------------------------------croma log compressa                        
    LE = log(1 + (bL ./ aL) .* Losa .* 10) ./ bL;
    GE=-g;
    JE=j;

    % coordinate in OSA-UCS log-compresso LE,GE,JE (unità uguale a 1 jnd),
    % indicate con LE,GE,JE

    LE(isnan(LE)) = 0;
   
end

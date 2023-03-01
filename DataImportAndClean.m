clc
clear
close all

report = ImportBookTokReport_2("3-BooktTok, cosa ci nascondi.csv");
savePath = "saveGraph/";
[status, msg, msgID] = mkdir(savePath);

% Global Category
Eta = categorical(["meno di 14", "14-18", "19-25", "26-35", "36-45", "più di 46"]);
Eta = reordercats(Eta,["meno di 14", "14-18", "19-25", "26-35", "36-45", "più di 46"]);

Occupazione = categorical(["Studente","Lavoratore","Disoccupato","Pensionato"]);
Occupazione = reordercats(Occupazione,["Studente","Lavoratore","Disoccupato","Pensionato"]);

siNoCat = categorical(["Si","No","Altri"]);
siNoCat = reordercats(siNoCat,["Si","No","Altri"]);

qualeSocial = categorical(["Youtube","Instagram","Tiktok","Twitter","Facebook", "Altri"]);
qualeSocial = reordercats(qualeSocial,["Youtube","Instagram","Tiktok","Twitter","Facebook", "Altri"]);

Comunita = categorical(["Parte di una Comunità","Lettore Solitario"]);

% Global ID
utentiParteComLib_Id = report.TiRitieniParteDiUnaComunitLibrosaOnlineBookTubeBookstagramBookT == "Si";
utentiNonParteComLib_Id = report.TiRitieniParteDiUnaComunitLibrosaOnlineBookTubeBookstagramBookT == "No";



%% A seconda dell'età, i generi che la gente preferisce (1 e 2)
T = report(:, ["Eta", "QualIlGenereChePreferisciLeggerepuoiSelezionarePiDiUnaRisposta"]);
generi = categorical(["Classici", "Fantasy e Avventura", "Fantascienza", "Giallo e Thriller", "Romanzo storico", "Romanzo rosa e Chick-lit", "Young Adult e New Adult", "Saggi e divulgazione scientifica", "Altri"]);

[eta_GeneriMatrix, eta_GeneriMatrixRowNorm, eta_GeneriMatrixColNorm]  = dualCategoryMatrixInterpolation(T, Eta, generi);

figure(1)
clf
[eta_GeneriMatrixCut, generiOrder1] = tableSortCol(eta_GeneriMatrix, 'descend', generi);
doubleBarPlotRowNorm(eta_GeneriMatrixCut, generiOrder1, Eta, "Analisi generi ed età",7);
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'01-Analisi generi ed età.pdf', '-dpdf')

figure(2)
clf
[eta_GeneriMatrixCutRowNorm, generiOrder2] = tableSortCol(eta_GeneriMatrixRowNorm, 'descend', generi);
doubleBarPlotRowNorm(eta_GeneriMatrixCutRowNorm, generiOrder2, Eta, "Analisi generi ed età[%]",7);
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'02-Analisi generi ed età[%].pdf', '-dpdf')

%% Libri letti per fascia di Età (3)
% Età, Quanti libri leggi in media in un anno (Scrivere il numero intero: Esempio: 25)
T = report(:, ["Eta", "QuantiLibriLeggiInMediaInUnAnnoScrivereIlNumeroInteroEsempio25"]);
hist3MultCategory(T, Eta, 15, 150, "Libri letti per fascia di Età[%]", 5)
view(65,30)
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'03-Libri letti per fascia di Età[%].pdf', '-dpdf')

%% Libri comprati per fascia di età (4)
T = report(:, ["Eta", "QuantiLibriCompriInMediaInUnAnnoTraUsatiENuoviScrivereIlNumeroI"]);
hist3MultCategory(T, Eta, 10, 100, "Libri comprati per fascia di Età[%]",4)
view(65,30)
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'04-Libri comprati per fascia di Età[%].pdf', '-dpdf')

%% I bookInfluenzer del report di quale social fanno parte (5)
T = report(:, ["UsiUnoDiQuestiAccountPerParlareDiLibriseiUnBookinfluencer", "SeHaiRispostoSAdAlmenoUnaDelleDueSpecificaQuali"]);

T_filterId = T.UsiUnoDiQuestiAccountPerParlareDiLibriseiUnBookinfluencer == "Si";
T_filter = T(T_filterId,:);

[suQualeSocialSeiInfluenzer,~,~] = dualCategoryMatrixInterpolation(T_filter, siNoCat, qualeSocial);
[suQualeSocialSeiInfluenzerCut, qualeSocialOrder] = tableSortCol(suQualeSocialSeiInfluenzer, 'descend', qualeSocial);
figure (5)
bar(qualeSocialOrder,suQualeSocialSeiInfluenzerCut(1,:)','stacked') % 1 perchè "Si" è la prima posizione
grid on
title("I bookInfluenzer del report di quale social fanno parte")
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'05-I bookInfluenzer del report di quale social fanno parte.pdf', '-dpdf')

%% Dove le persone cercano informazioni sulla lettura (6)
T = report(:, ["UsiUnoDiQuestiAccountSoloPerCercareConsigliSuiLibrinonSeiUnBook", "SeHaiRispostoSAdAlmenoUnaDelleDueSpecificaQuali"]);

T_filterId = T.UsiUnoDiQuestiAccountSoloPerCercareConsigliSuiLibrinonSeiUnBook == "Si";
T_filter = T(T_filterId,:);

[suQualeSocialSeiInfluenzer,~,~] = dualCategoryMatrixInterpolation(T_filter, siNoCat, qualeSocial);
[suQualeSocialSeiInfluenzerCut, qualeSocialOrder] = tableSortCol(suQualeSocialSeiInfluenzer, 'descend', qualeSocial);
figure (6)
bar(qualeSocialOrder,suQualeSocialSeiInfluenzerCut(1,:)','stacked') % 1 perchè "Si" è la prima posizione
grid on
title("Dove le persone del report cercano informazioni sulla lettura")
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'06-Dove le persone del report cercano informazioni sulla lettura.pdf', '-dpdf')

%% L'impatto di tiktok rispetto all'età (7)
report_filterId = report.ConosciBooktok == "Si" & ~isundefined(report.QuantoSonoCambiateLeTueAbitudiniDiLetturaDaQuandoSeiEntratoNelB);
report_filter = report(report_filterId,:);
T = report_filter(:, ["Eta", "QuantoSonoCambiateLeTueAbitudiniDiLetturaDaQuandoSeiEntratoNelB"]);

% TODO: modificare a mano i dati e mettere insieme 
% "Prima di conoscere Booktok non leggevo" con "Prima di conscese Booktok non leggevo"
Abitudini = categorical(categories(T.QuantoSonoCambiateLeTueAbitudiniDiLetturaDaQuandoSeiEntratoNelB));

[cambioAbitudiniNum,cambioAbitudini,~] = dualCategoryMatrixInterpolation(T, Eta, Abitudini);
figure(7)
[cambioAbitudiniCut, AbitudiniOrder] = tableSortCol(cambioAbitudini, 'ascend', Abitudini);
doubleBarHPlot(cambioAbitudiniCut, AbitudiniOrder, Eta, "L'impatto su coloro che conoscono tiktok rispetto all'età [%]");
set(gcf,'Position',[0 0 2000 500])
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"07-L'impatto su coloro che conoscono tiktok rispetto all'età [%].pdf", '-dpdf')

%% Uso dei Supporti [%] (8)
% asse y su due livelli/valori chi si considera parte di una comunità librosa, 
% asse x le varie età,
% asse z la percentuale per ogni fascia di età che legge con un certo supporto

col = ["Eta", "ConQualeSupportoPreferisciLeggereSelezionaTuttiQuelliCheUsi"];

utentiParteComLib = report(utentiParteComLib_Id,:);
TSi = utentiParteComLib(:, col);
utentiNonParteComLib = report(utentiNonParteComLib_Id,:);
TNo = utentiNonParteComLib(:, col);

Supporto = categorical(["Audiolibro","Cartaceo","Ebook"]);

figure(8)
Bar3dPlotNLevel({TSi,TNo}, Comunita, Eta, Supporto)
title("Uso dei Supporti [%]")
alpha(.8)
view(-75,10)
set(gcf,'PaperOrientation','portrait');
print(gcf,'-vector','-bestfit', savePath+'08-Uso dei Supporti [%].pdf', '-dpdf')


%% Tempo di lettura in base all'occupazione [%](9)
T = report(:, ["Occupazione", "MediamenteASettimanaQuantoTempoPassiALeggere"]);
T.MediamenteASettimanaQuantoTempoPassiALeggere = fillmissing(T.MediamenteASettimanaQuantoTempoPassiALeggere, 'constant', "meno di un'ora");

TempoMedioLettura = categorical(["meno di un'ora", "1 o 2 ore", "dalle 3 alle 6 ore", "dalle 7 alle 10 ore", "Più di 10 ore"]);
TempoMedioLettura = reordercats(TempoMedioLettura,["meno di un'ora", "1 o 2 ore", "dalle 3 alle 6 ore", "dalle 7 alle 10 ore", "Più di 10 ore"]);
[~, occupazioneTempoLettura, ~]  = dualCategoryMatrixInterpolation(T, Occupazione, TempoMedioLettura);

figure(9)
clf
doubleBarPlotRowNorm(occupazioneTempoLettura{1:end-1,1:end-1}, TempoMedioLettura, Occupazione, "Tempo di lettura in base all'occupazione [%]",4);
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"09-Tempo di lettura in base all'occupazione [%].pdf", '-dpdf')

%% Comunità Librose ed Eta [%] (10)
report_filterId = ~isundefined(report.SeHaiRispostoSAdAlmenoUnaDelleDueSpecificaQuali);
report_filter = report(report_filterId,:);
T = report_filter(:, ["Eta", "SeHaiRispostoSAdAlmenoUnaDelleDueSpecificaQuali"]);
[~, ~, comunitaLibroseEta]  = dualCategoryMatrixInterpolation(T, Eta, qualeSocial);
figure(10)
clf
doubleBarPlotColNorm(comunitaLibroseEta{1:end-1,1:end-1}, Eta, qualeSocial, "Comunità Librose ed Eta [%]",0);
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"10-Comunità Librose ed Eta [%].pdf", '-dpdf')

%% Quanto sei disposto a spendere in relazione all'appartenenza ad una comunita (11)
col = ["Eta", "QualIlPrezzoMassimoCheSeiDispostoASpenderePerUnLibro"];

utentiParteComLib = report(utentiParteComLib_Id,:);
TSi = utentiParteComLib(:, col);
utentiNonParteComLib = report(utentiNonParteComLib_Id,:);
TNo = utentiNonParteComLib(:, col);

sogliaSpesa = categorical(categories(report.QualIlPrezzoMassimoCheSeiDispostoASpenderePerUnLibro));

figure(11)
Bar3dPlotNLevel({TSi,TNo}, Comunita, Eta, sogliaSpesa)
title("Uso dei Supporti [%]")
alpha(.7)
view(45,20)
set(gcf,'Position',[0 0 1600 1200])
set(gcf,'PaperOrientation','portrait');
print(gcf,'-vector','-bestfit', savePath+"11-Quanto sei disposto a spendere in relazione all'appartenenza ad una comunita.pdf", '-dpdf')




function Bar3dPlotNLevel(TList, catTList, catBar, catOriz)
    if (length(TList) ~= length(catTList))
        error("Numero Tabelle, e Numero categorie diverse")
    end

    spessore=length(TList);
    catMatrixList = cell(1,spessore);
    for sp = 1 : spessore
        [~,catMatrixList{sp},~] = dualCategoryMatrixInterpolation(TList{sp}, catBar, catOriz);
    end
    
    array = zeros([length(catOriz),spessore,length(catBar)]);
    for level = 1:length(catBar)
        vector=zeros(length(catOriz),spessore);
        for sp = 1 : spessore
            vector(:,sp)= catMatrixList{sp}{level,1:end-1}';
        end
        array(:,:,level) = vector;
    end
    
    stacked_bar3(array);
    grid on
    set(gca,'YTickLabel',catOriz)
    set(gca,'ytick',1:length(catOriz))
    set(gca,'ylim',[0.5,length(catOriz)+0.5])
    
    set(gca,'XTickLabel',catTList)
    set(gca,'xtick',1:spessore)
    set(gca,'xlim',[0.5,spessore+0.5])

    legend(catBar,'Location', 'northeast')
end

% Prima colonna la categoria, seconda colonna i numeri
function hist3MultCategory(reportColTable, categoryValue, slotSize, maxFixed, titleStr, figNum)
    catColName = reportColTable.Properties.VariableNames{1};
    
    valueColName = reportColTable.Properties.VariableNames{2};
    maxValue = max(reportColTable{:,valueColName});

    RangeMin = 0;
    RangeMax = min(maxValue,maxFixed);
    slot = ceil((RangeMax - RangeMin)/slotSize);
    yRange = RangeMin + (RangeMax - RangeMin)/slot * (1:slot);
    
    subHist = zeros(length(categoryValue), slot);
    for catId = 1:length(categoryValue)
        idx = reportColTable{:,catColName} == categoryValue(catId);
        subTab = reportColTable(idx,:);
        h = hist(subTab{:,valueColName}, yRange);
        hNorm = h./sum(h);
        subHist(catId,:) = hNorm;
    end
    
    textRange = [];
    for i = 1:(length(yRange))
        if i == 1
            minText = 0;
        else
            minText = yRange(i-1);
        end
        textRange = [textRange, minText + "-" + yRange(i)];
    end
    figure(figNum)
    bar3(subHist')
    set(gca,'XTickLabel',categoryValue)
    set(gca,'xtick',1:length(categoryValue))
    set(gca,'xlim',[0.5,length(categoryValue) + 0.5])
    
    set(gca,'YTickLabel',textRange)
    set(gca,'ytick',1:length(textRange))
    set(gca,'ylim',[0.5,length(textRange) + 0.5])
    alpha(0.75)

    title(titleStr)
    ylim(0.5 + [0 slot])
end

function doubleBarPlotColNorm(tableMatrix, xNameCategory, subBarCategory, titleString, fitLevel)
bar(xNameCategory,tableMatrix,'stacked');
if fitLevel > 0
    hold on
    barSum = nansum(tableMatrix,2)';
    barSumDysplayOrder(grp2idx(xNameCategory)) = barSum;
    % Fitta usando un polinomio
    p = polyfit(1:length(xNameCategory),barSumDysplayOrder,fitLevel);
    xFit = 1:.1:length(grp2idx(xNameCategory));
    yFit = polyval(p,xFit);
    plot(1:length(xNameCategory),barSumDysplayOrder,'ro',xFit,yFit,'-r') % Trend Line
end
legend(subBarCategory)
grid on
title(titleString)
end

function doubleBarPlotRowNorm(tableMatrix, xNameCategory, subBarCategory, titleString, fitLevel)
bar(xNameCategory,tableMatrix,'stacked');
hold on
if fitLevel > 0
    barSum = nansum(tableMatrix);
    barSumDysplayOrder(grp2idx(xNameCategory)) = barSum;
    % Fitta usando un polinomio
    p = polyfit(1:length(xNameCategory),barSumDysplayOrder,fitLevel);
    xFit = 1:.1:length(grp2idx(xNameCategory));
    yFit = polyval(p,xFit);
    plot(1:length(xNameCategory),barSumDysplayOrder,'ro',xFit,yFit,'-r') % Trend Line
end
legend(subBarCategory)
grid on
title(titleString)
end


function doubleBarHPlot(tableMatrix, xNameCategory, subBarCategory, titleString)
barh(xNameCategory,tableMatrix,'stacked')
legend(subBarCategory, 'Location', 'southeast')
grid on
title(titleString)
end

% Reorder colums of table based on sum of culoms
function [matrixCut, newColOrder] = tableSortCol(tableOriginal, sortType, colCategory)
[sortedY, sortOrder] = sort(tableOriginal{"SumCols",1:end-1}, sortType);
newColOrder = reordercats(colCategory, string(colCategory(sortOrder)));
matrixCut = tableOriginal{1:end-1,1:end-1};
end


% Funzione che prende in ingresso ana tabella di 2 colonne con N colonne,
% e le trasforma in una matrice che interseca le risposte.
% Potenzialmente entrambe le colonne possono essere a scelta multipla,
% basta che le variabili rowCategory e colCategory siano scritte opportunamente.
% L'eventuale colonna "Altri" va aggiunta prima di passare la categoria qui.
% Le 2 colonne di reportColTable in base all'ordine diventano riga o
% colonna della matrice risultante
function [matrixTab, normRow, normCol] = dualCategoryMatrixInterpolation(reportColTable, rowCategory, colCategory)
    matrixTab = array2table(zeros(length(rowCategory),length(colCategory)), ...
        'RowNames', cellstr(rowCategory), 'VariableNames',cellstr(colCategory));
    originalColName = reportColTable.Properties.VariableNames;
    
    % Analize all row of the 'originalTab'
    table_size = size(reportColTable); 
    rows = table_size(1); 
    for rowIndexOriginal = 1:rows 
        % To access a row in the table, use T(row,:)
        rowTab = reportColTable(rowIndexOriginal,:);
        rowNames = split(string(rowTab.(originalColName{1})),";");
        colNames = split(string(rowTab.(originalColName{2})),";");
        for row = 1:length(rowNames)
            row = rowNames(row);
            if ~ismember(row,rowCategory)
                row = "Altri";
            end
            for col = 1:length(colNames)
                col = colNames(col);
                if ~ismember(col,colCategory)
                    col = "Altri";
                end
                matrixTab{row, col} = matrixTab{row, col} + 1;
            end
        end
    end
    matrixTab("SumCols",:) = array2table(nansum(matrixTab{:,:}));
    matrixTab(:,"SumRows") = array2table(nansum(matrixTab{:,:}')');
    normRow = matrixTab{:,:}./matrixTab{:,"SumRows"};
    normRow(end,:) = nansum(normRow(1:end-1,:));
    normRow = array2table(normRow, 'RowNames', matrixTab.Row, 'VariableNames', matrixTab.Properties.VariableNames);
        
    normCol = matrixTab{:,:}./matrixTab{"SumCols",:};
    normCol(:,end) = nansum(normCol(:,1:end-1),2);
    normCol = array2table(normCol, 'RowNames', matrixTab.Row, 'VariableNames', matrixTab.Properties.VariableNames);
end

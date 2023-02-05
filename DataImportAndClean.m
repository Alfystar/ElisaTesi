clc
clear
close all

report = ImportBookTokReport_2("2-BooktTok, cosa ci nascondi.csv");
savePath = "saveGraph/"
[status, msg, msgID] = mkdir(savePath);
% Analizzarre la colonna 'QualIlTuoBookinfluencerPreferito' per trovare le
% parole più usate e fare un grafico di parole


%% A seconda dell'età, i generi che la gente preferisce (1 e 2)
T = report(:, ["Eta", "QualIlGenereChePreferisciLeggerepuoiSelezionarePiDiUnaRisposta"]);
generi = categorical(["Classici", "Fantasy e Avventura", "Fantascienza", "Giallo e Thriller", "Romanzo storico", "Romanzo rosa e Chick-lit", "Young Adult e New Adult", "Saggi e divulgazione scientifica", "Altri"]);
Eta = categorical(categories(T.Eta));

[eta_GeneriMatrix, eta_GeneriMatrixRowNorm, eta_GeneriMatrixColNorm]  = dualCategoryMatrixInterpolation(T, Eta, generi);

figure(1)
[eta_GeneriMatrixCut, generiOrder1] = tableSortCol(eta_GeneriMatrix, 'descend', generi);
doubleBarPlot(eta_GeneriMatrixCut, generiOrder1, Eta, "Analisi generi ed età");
saveas(gcf,savePath+'Analisi generi ed età.pdf')

figure(2)
[eta_GeneriMatrixCutRowNorm, generiOrder2] = tableSortCol(eta_GeneriMatrixRowNorm, 'descend', generi);
doubleBarPlot(eta_GeneriMatrixCutRowNorm, generiOrder2, Eta, "Analisi generi ed età[%]");
saveas(gcf,savePath+'Analisi generi ed età[%].pdf')

%% Libri letti per fascia di Età (3)
% Età, Quanti libri leggi in media in un anno (Scrivere il numero intero: Esempio: 25)
T = report(:, ["Eta", "QuantiLibriLeggiInMediaInUnAnnoScrivereIlNumeroInteroEsempio25"]);
hist3MultCategory(T, 15, 150, "Libri letti per fascia di Età[%]", 3)
view(-70,40)
saveas(gcf,savePath+'Libri letti per fascia di Età[%].pdf')

%% Libri comprati per fascia di età (4)
T = report(:, ["Eta", "QuantiLibriCompriInMediaInUnAnnoTraUsatiENuoviScrivereIlNumeroI"]);
hist3MultCategory(T, 10, 100, "Libri comprati per fascia di Età[%]",4)
view(-70,40)
saveas(gcf,savePath+'Libri comprati per fascia di Età[%].pdf')

%% I bookInfluenzer del report di quale social fanno parte (5)
T = report(:, ["UsiUnoDiQuestiAccountPerParlareDiLibriseiUnBookinfluencer", "SeHaiRispostoSAdAlmenoUnaDelleDueSpecificaQuali"]);

T_filterId = T.UsiUnoDiQuestiAccountPerParlareDiLibriseiUnBookinfluencer == "Si";
T_filter = T(T_filterId,:);

siNoCat = categorical(["Si","No","Altri"]);
qualeSocial = categorical(["Altri","Youtube","Instagram","Tiktok","Twitter","Facebook"]);

[suQualeSocialSeiInfluenzer,~,~] = dualCategoryMatrixInterpolation(T_filter, siNoCat, qualeSocial);
[suQualeSocialSeiInfluenzerCut, qualeSocialOrder] = tableSortCol(suQualeSocialSeiInfluenzer, 'descend', qualeSocial);
figure (5)
bar(qualeSocialOrder,suQualeSocialSeiInfluenzerCut(1,:)','stacked') % 1 perchè "Si" è la prima posizione
grid on
title("I bookInfluenzer del report di quale social fanno parte")
saveas(gcf,savePath+'I bookInfluenzer del report di quale social fanno parte.pdf')

%% Dove le persone cercano informazioni sulla lettura (6)
T = report(:, ["UsiUnoDiQuestiAccountSoloPerCercareConsigliSuiLibrinonSeiUnBook", "SeHaiRispostoSAdAlmenoUnaDelleDueSpecificaQuali"]);

T_filterId = T.UsiUnoDiQuestiAccountSoloPerCercareConsigliSuiLibrinonSeiUnBook == "Si";
T_filter = T(T_filterId,:);

siNoCat = categorical(["Si","No","Altri"]);
qualeSocial = categorical(["Altri","Youtube","Instagram","Tiktok","Twitter","Facebook"]);


[suQualeSocialSeiInfluenzer,~,~] = dualCategoryMatrixInterpolation(T_filter, siNoCat, qualeSocial);
[suQualeSocialSeiInfluenzerCut, qualeSocialOrder] = tableSortCol(suQualeSocialSeiInfluenzer, 'descend', qualeSocial);
figure (6)
bar(qualeSocialOrder,suQualeSocialSeiInfluenzerCut(1,:)','stacked') % 1 perchè "Si" è la prima posizione
grid on
title("Dove le persone del report cercano informazioni sulla lettura")
saveas(gcf,savePath+'Dove le persone del report cercano informazioni sulla lettura.pdf')

%% L'impatto di tiktok rispetto all'età (7)
report_filterId = report.ConosciBooktok == "Si" & ~isundefined(report.QuantoSonoCambiateLeTueAbitudiniDiLetturaDaQuandoSeiEntratoNelB);
report_filter = report(report_filterId,:);
T = report_filter(:, ["Eta", "QuantoSonoCambiateLeTueAbitudiniDiLetturaDaQuandoSeiEntratoNelB"]);

Eta = categorical(categories(T.Eta));
% TODO: modificare a mano i dati e mettere insieme 
% "Prima di conoscere Booktok non leggevo" con "Prima di conscese Booktok non leggevo"
Abitudini = categorical(categories(T.QuantoSonoCambiateLeTueAbitudiniDiLetturaDaQuandoSeiEntratoNelB));

[~,cambioAbitudini,~] = dualCategoryMatrixInterpolation(T, Eta, Abitudini)
figure(7)
[cambioAbitudiniCut, AbitudiniOrder] = tableSortCol(cambioAbitudini, 'ascend', Abitudini);
doubleBarHPlot(cambioAbitudiniCut, AbitudiniOrder, Eta, "L'impatto di tiktok rispetto all'età [%]");
saveas(gcf,savePath+"L'impatto di tiktok rispetto all'età [%].pdf")




% Prima colonna la categoria, seconda colonna i numeri
function hist3MultCategory(reportColTable, slotSize, maxFixed, titleStr, figNum)
    catColName = reportColTable.Properties.VariableNames{1};
    categoryValue = categorical(categories(reportColTable{:,catColName}));
    
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
    set(gca,'YTickLabel',textRange)
    title(titleStr)
    ylim(0.5 + [0 slot])
end


function doubleBarPlot(tableMatrix, xNameCategory, subBarCategory, titleString)
bar(xNameCategory,tableMatrix,'stacked')
legend(subBarCategory)
grid on
title(titleString)
end


function doubleBarHPlot(tableMatrix, xNameCategory, subBarCategory, titleString)
barh(xNameCategory,tableMatrix,'stacked')
legend(subBarCategory)
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
    normRow(end,:) = nansum(normRow);
    normRow = array2table(normRow, 'RowNames', matrixTab.Row, 'VariableNames', matrixTab.Properties.VariableNames);
        
    normCol = matrixTab{:,:}./matrixTab{"SumCols",:};
    normCol(:,end) = nansum(normCol,2);
    normCol = array2table(normCol, 'RowNames', matrixTab.Row, 'VariableNames', matrixTab.Properties.VariableNames);
end

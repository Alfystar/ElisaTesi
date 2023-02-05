clc
clear

report = ImportBookTokReport_2("1-BooktTok, cosa ci nascondi.csv");

% Analizzarre la colonna 'QualIlTuoBookinfluencerPreferito' per trovare le
% parole più usate e fare un grafico di parole


% A seconda dell'età, i generi che la gente preferisce
% report.Eta, report.QualIlGenereChePreferisciLeggerepuoiSelezionarePiDiUnaRisposta
T = report(:, ["Eta", "QualIlGenereChePreferisciLeggerepuoiSelezionarePiDiUnaRisposta"]);
generi = categorical(["Classici", "Fantasy e Avventura", "Fantascienza", "Giallo e Thriller", "Romanzo storico", "Romanzo rosa e Chick-lit", "Young Adult e New Adult", "Saggi e divulgazione scientifica", "Altri"]);
Eta = categorical(categories(T.Eta));

[eta_GeneriMatrix, eta_GeneriMatrixRowNorm, eta_GeneriMatrixColNorm]  = dualCategoryMatrixInterpolation(T, Eta, generi)

[eta_GeneriMatrixCutRowNorm, generiOrder1] = tableSortCol(eta_GeneriMatrixRowNorm, 'descend', generi)
[eta_GeneriMatrixCutColNorm, generiOrder2] = tableSortCol(eta_GeneriMatrixColNorm, 'descend', generi)

figure(1)
doubleBarPlot(eta_GeneriMatrixCutRowNorm, generiOrder1, Eta, "Analisi generi ed età")

figure(2)
doubleBarPlot(eta_GeneriMatrixCutColNorm, generiOrder2, Eta, "Analisi generi ed età")


function doubleBarPlot(tableMatrix, xNameCategory, subBarCategory, titleString)
bar(xNameCategory,tableMatrix,'stacked')
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
    matrixTab("SumCols",:) = array2table(sum(matrixTab{:,:}));
    matrixTab(:,"SumRows") = array2table(sum(matrixTab{:,:}')');
    normRow = matrixTab{:,:}./matrixTab{:,"SumRows"};
    normRow = array2table(normRow, 'RowNames', matrixTab.Row, 'VariableNames', matrixTab.Properties.VariableNames);
    normCol = matrixTab{:,:}./matrixTab{"SumCols",:};
    normCol = array2table(normCol, 'RowNames', matrixTab.Row, 'VariableNames', matrixTab.Properties.VariableNames);
end

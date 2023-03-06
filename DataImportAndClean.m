%  To run install:
% - https://it.mathworks.com/matlabcentral/fileexchange/69063-matlab-table-to-latex-conversor
% - polyfit toolbox
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

siNoAltri = categorical(["Si","No","Altri"]);
siNoAltri = reordercats(siNoAltri,["Si","No","Altri"]);

siNoCat = categorical(["Si","No"]);
siNoCat = reordercats(siNoCat,["Si","No"]);

qualeSocial = categorical(["Youtube","Instagram","Tiktok","Twitter","Facebook", "Altri"]);
qualeSocial = reordercats(qualeSocial,["Youtube","Instagram","Tiktok","Twitter","Facebook", "Altri"]);

Comunita = categorical(["Parte di una Community","Lettore Solitario"]);

prezzoInfluisce = categorical(["Il prezzo influisce","Il prezzo non influisce"]);

sogliaSpesa = categorical(categories(report.QualIlPrezzoMassimoCheSeiDispostoASpenderePerUnLibro));
sogliaSpesaRename = renamecats(sogliaSpesa,{'Se il libro mi interessa non importa il prezzo'},{'Se interessa  non ha prezzo'});

voto1_5 = categorical({'1', '2', '3', '4', '5'});

% Global ID
utentiParteComLib_Id = report.TiRitieniParteDiUnaComunitLibrosaOnlineBookTubeBookstagramBookT == "Si";
utentiNonParteComLib_Id = report.TiRitieniParteDiUnaComunitLibrosaOnlineBookTubeBookstagramBookT == "No";

utentiFrenatiDalPrezzo_Id = report.IlPrezzoDiUnLibroTiFrenaDalComprarlo == "Si";
utentiNonFrenatiDalPrezzo_Id = report.IlPrezzoDiUnLibroTiFrenaDalComprarlo == "No";


%% A seconda dell'età, i generi che la gente preferisce (1 e 2)
T = report(:, ["Eta", "QualIlGenereChePreferisciLeggerepuoiSelezionarePiDiUnaRisposta"]);
generi = categorical(["Classici", "Fantasy e Avventura", "Fantascienza", "Giallo e Thriller", "Romanzo storico", "Romanzo rosa e Chick-lit", "Young Adult e New Adult", "Saggi e divulgazione scientifica", "Altri"]);

[eta_GeneriMatrix, eta_GeneriMatrixRowNorm, ~]  = dualCategoryMatrixInterpolation(T, Eta, generi);

figure(1)
clf
[eta_GeneriMatrixCut, generiOrder1] = tableSortCol(eta_GeneriMatrix, 'descend', generi);
barPlotRowNorm(eta_GeneriMatrixCut, generiOrder1, Eta, "Analisi generi ed età",7);
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'01-Analisi generi ed età.pdf', '-dpdf')
table2latex(eta_GeneriMatrix,char(savePath+'01-Analisi generi ed età.tex'))
figure(2)
clf
[eta_GeneriMatrixCutRowNorm, generiOrder2] = tableSortCol(eta_GeneriMatrixRowNorm, 'descend', generi);
barPlotRowNorm(eta_GeneriMatrixCutRowNorm, generiOrder2, Eta, "Analisi generi ed età[%]",7);
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'02-Analisi generi ed età-perc.pdf', '-dpdf')
table2latex(eta_GeneriMatrixRowNorm,char(savePath+'02-Analisi generi ed età-perc.tex'))

%% Libri letti per fascia di Età (3)
% Età, Quanti libri leggi in media in un anno (Scrivere il numero intero: Esempio: 25)
T = report(:, ["Eta", "QuantiLibriLeggiInMediaInUnAnnoScrivereIlNumeroInteroEsempio25"]);
hist3MultCategory(T, Eta, 10, 70, "Libri letti per fascia di Età[%]", 3)
view(65,30)
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'03-Libri letti per fascia di Età-perc.pdf', '-dpdf')

%% Libri comprati per fascia di età (4)
T = report(:, ["Eta", "QuantiLibriCompriInMediaInUnAnnoTraUsatiENuoviScrivereIlNumeroI"]);
hist3MultCategory(T, Eta, 10, 60, "Libri comprati per fascia di Età[%]",4)
view(65,30)
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'04-Libri comprati per fascia di Età-perc.pdf', '-dpdf')

%% I bookInfluenzer del report di quale social fanno parte (5)
T_filterId = report.UsiUnoDiQuestiAccountPerParlareDiLibriseiUnBookinfluencer == "Si";
T_filter = report(T_filterId,["SeHaiRispostoSAdAlmenoUnaDelleDueSpecificaQuali","Eta"]);

[suQualeSocialSeiInfluenzer,~,~] = dualCategoryMatrixInterpolation(T_filter, qualeSocial, Eta);
[suQualeSocialSeiInfluenzerCut, qualeSocialOrder] = tableSortRow(suQualeSocialSeiInfluenzer, 'descend', qualeSocial);
figure(5)
clf
barPlotColNorm(suQualeSocialSeiInfluenzerCut, qualeSocialOrder, Eta, "I Book-Influencer del report di quale social fanno parte",3);
% colNormTopTextBar(suQualeSocialSeiInfluenzer, qualeSocialOrder)
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'05-I bookInfluenzer del report di quale social fanno parte.pdf', '-dpdf')
table2latex(suQualeSocialSeiInfluenzer,char(savePath+'05-I bookInfluenzer del report di quale social fanno parte.tex'))

%% Dove le persone, divise per Eta, cercano informazioni sulla lettura [%](6)
T_filterId = report.UsiUnoDiQuestiAccountSoloPerCercareConsigliSuiLibrinonSeiUnBook == "Si";
T_filter = report(T_filterId,["SeHaiRispostoSAdAlmenoUnaDelleDueSpecificaQuali", "Eta"]);

[suQualeSocialCerciLibriClear,~,suQualeSocialCerciLibri] = dualCategoryMatrixInterpolation(T_filter, qualeSocial, Eta);
[suQualeSocialCerciLibriCut, qualeSocialOrder] = tableSortRow(suQualeSocialCerciLibri, 'descend', qualeSocial);
figure(6)
clf
barPlotColNorm(suQualeSocialCerciLibriCut, qualeSocialOrder, Eta, "Dove le persone del report cercano informazioni sulla lettura divise per Età [%]",2);
% colNormTopTextBar(suQualeSocialCerciLibri, qualeSocialOrder)
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'06-Dove le persone del report cercano informazioni sulla lettura divise per eta-perc.pdf', '-dpdf')
table2latex(suQualeSocialCerciLibri,char(savePath+'06-Dove le persone del report cercano informazioni sulla lettura divise per eta-perc.tex'))
table2latex(suQualeSocialCerciLibriClear,char(savePath+'06-Dove le persone del report cercano informazioni sulla lettura divise per eta-clear.tex'))


%% L'impatto di tiktok rispetto all'età (7)
report_filterId = report.ConosciBooktok == "Si" & ~isundefined(report.QuantoSonoCambiateLeTueAbitudiniDiLetturaDaQuandoSeiEntratoNelB);
report_filter = report(report_filterId,:);
T = report_filter(:, ["Eta", "QuantoSonoCambiateLeTueAbitudiniDiLetturaDaQuandoSeiEntratoNelB"]);

% TODO: modificare a mano i dati e mettere insieme 
% "Prima di conoscere Booktok non leggevo" con "Prima di conscese Booktok non leggevo"
Abitudini = categorical(categories(T.QuantoSonoCambiateLeTueAbitudiniDiLetturaDaQuandoSeiEntratoNelB));

[cambioAbitudiniNum,cambioAbitudini,~] = dualCategoryMatrixInterpolation(T, Eta, Abitudini);
figure(7)
clf
[cambioAbitudiniCut, AbitudiniOrder] = tableSortCol(cambioAbitudini, 'ascend', Abitudini);
doubleBarHPlot(cambioAbitudiniCut, AbitudiniOrder, Eta, "L'impatto su coloro che conoscono Tiktok rispetto all'età [%]");
set(gcf,'Position',[0 0 2000 500])
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"07-L'impatto su coloro che conoscono tiktok rispetto all'età-perc.pdf", '-dpdf')
table2latex(cambioAbitudini,char(savePath+"07-L'impatto su coloro che conoscono tiktok rispetto all'età-perc.tex"))
table2latex(cambioAbitudiniNum,char(savePath+"07-L'impatto su coloro che conoscono tiktok rispetto all'età-clear.tex"))

%% Uso dei Supporti [%] (8)
% asse y su due livelli/valori chi si considera parte di una Community librosa, 
% asse x le varie età,
% asse z la percentuale per ogni fascia di età che legge con un certo supporto

col = ["Eta", "ConQualeSupportoPreferisciLeggereSelezionaTuttiQuelliCheUsi"];

utentiParteComLib = report(utentiParteComLib_Id,:);
TSi = utentiParteComLib(:, col);
utentiNonParteComLib = report(utentiNonParteComLib_Id,:);
TNo = utentiNonParteComLib(:, col);

Supporto = categorical(["Audiolibro","Cartaceo","Ebook"]);

figure(8)
clf
Bar3dPlotNLevel({TSi,TNo}, Comunita, Eta, Supporto)
title("Uso dei Supporti [%]")
alpha(.8)
view(-75,10)
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'08-Uso dei Supporti-perc.pdf', '-dpdf')


%% Tempo di lettura in base all'occupazione [%](9)
T = report(:, ["Occupazione", "MediamenteASettimanaQuantoTempoPassiALeggere"]);
T.MediamenteASettimanaQuantoTempoPassiALeggere = fillmissing(T.MediamenteASettimanaQuantoTempoPassiALeggere, 'constant', "meno di un'ora");
oldcats = {'Lavoratore', 'Pensionato'};
T.Occupazione = mergecats(T.Occupazione,oldcats);


TempoMedioLettura = categorical(["meno di un'ora", "1 o 2 ore", "dalle 3 alle 6 ore", "dalle 7 alle 10 ore", "Più di 10 ore"]);
TempoMedioLettura = reordercats(TempoMedioLettura,["meno di un'ora", "1 o 2 ore", "dalle 3 alle 6 ore", "dalle 7 alle 10 ore", "Più di 10 ore"]);
[occupazioneTempoLetturaNum, occupazioneTempoLettura, ~]  = dualCategoryMatrixInterpolation(T, categorical(categories(T.Occupazione)), TempoMedioLettura);

figure(9)
clf
barPlotRowNorm(occupazioneTempoLettura{1:end-1,1:end-1}, TempoMedioLettura, categories(T.Occupazione), "Tempo di lettura in base all'occupazione [%]",3);
Y = occupazioneTempoLettura{"SumCols",:};
text(1:length(Y),Y,num2str(Y'),'vert','bottom','horiz','center');
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"09-Tempo di lettura in base all'occupazione-perc.pdf", '-dpdf')
table2latex(occupazioneTempoLettura,char(savePath+"09-Tempo di lettura in base all'occupazione-perc.tex"))
table2latex(occupazioneTempoLetturaNum,char(savePath+"09-Tempo di lettura in base all'occupazione-clear.tex"))

%% Comunità Librose ed Eta [%] (10)
report_filterId = ~isundefined(report.SeHaiRispostoSAdAlmenoUnaDelleDueSpecificaQuali);
report_filter = report(report_filterId,:);
T = report_filter(:, ["Eta", "SeHaiRispostoSAdAlmenoUnaDelleDueSpecificaQuali"]);
[comunitaLibroseEtaNum, comunitaLibroseEta , ~]  = dualCategoryMatrixInterpolation(T, Eta, qualeSocial);

figure(10)
clf
barPlotRowNorm(comunitaLibroseEta{1:end-1,1:end-1}, Eta, qualeSocial, ["Distribuzione delle Età [%]","nelle Community Librose"],0);
set(gca,'Xdir','reverse')
legend('Location','bestoutside')
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"10-Distribuzione delle Eta [perc] nelle Community Librose-perc.pdf", '-dpdf')
table2latex(comunitaLibroseEta,char(savePath+"10-Distribuzione delle Eta [perc] nelle Community Librose-perc.tex"))
table2latex(comunitaLibroseEtaNum,char(savePath+"10-Distribuzione delle Eta [perc] nelle Community Librose-clear.tex"))

%% Quanto sei disposto a spendere in relazione all'appartenenza ad una comunita (11)
col = ["Eta", "QualIlPrezzoMassimoCheSeiDispostoASpenderePerUnLibro"];

TSi = report(utentiParteComLib_Id, col);
TNo = report(utentiNonParteComLib_Id, col);

figure(11)
clf
Bar3dPlotNLevel({TSi,TNo}, Comunita, Eta, sogliaSpesa)
set(gca,'YTickLabel',sogliaSpesaRename)
title("Soglia massima di budget in base all'età")
legend('Location','northwest')
alpha(.7)
view(45,20)
set(gcf,'Position',[0 0 1600 1200])
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"11-Quanto sei disposto a spendere in relazione all'appartenenza ad una comunita.pdf", '-dpdf')


%% IL PREZZO DI UN LIBRO TI FRENA DAL COMPRARLO? Come il prezzo influisce sulla scelta dello stato del libro da acquistare (12)
col = ["Eta", "PreferisciCompareLibri"];

TSi = report(utentiFrenatiDalPrezzo_Id, col);
TNo = report(utentiNonFrenatiDalPrezzo_Id, col);

statoLibro = categories(report.PreferisciCompareLibri);

figure(12)
clf
Bar3dPlotNLevel({TSi,TNo}, prezzoInfluisce, Eta, statoLibro)
title(["IL PREZZO DI UN LIBRO TI FRENA DAL COMPRARLO?","Come il prezzo influisce sullo stato del libro da acquistare [%]"])
legend('Location','northwest')
alpha(.8)
view(-100,10)
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'12-IL PREZZO DI UN LIBRO TI FRENA DAL COMPRARLO-Come il prezzo influisce sulla scelta dello stato del libro da acquistare.pdf', '-dpdf')

%% IL PREZZO DI UN LIBRO TI FRENA DAL COMPRARLO? Qual è la discriminante quando compri dei libri (13)
col = ["Eta", "QualIlPrezzoMassimoCheSeiDispostoASpenderePerUnLibro"];

TSi = report(utentiFrenatiDalPrezzo_Id, col);
TNo = report(utentiNonFrenatiDalPrezzo_Id, col);

statoLibro = categories(report.PreferisciCompareLibri);
figure(13)
clf
Bar3dPlotNLevel({TSi,TNo}, prezzoInfluisce, Eta, sogliaSpesa)
title(["IL PREZZO DI UN LIBRO TI FRENA DAL COMPRARLO?","Qual è la discriminante quando compri dei libri [%]"])
set(gca,'YTickLabel',sogliaSpesaRename)
legend('Location','northwest')
alpha(.8)
view(70,20)
set(gcf,'Position',[0 0 2000 1600])
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'13-IL PREZZO DI UN LIBRO TI FRENA DAL COMPRARLO-Qual è la discriminante quando compri dei libri.pdf', '-dpdf')

%% Con quanta frequenza ti capitano nei "per te" o nel "feed" video o post del BookTok, BookTube o Bookstagram (14)
T = report(:, ["Eta", "Da1A5ConQuantaFrequenzaTiCapitanoNeiperTeONelfeedVideoOPostDelB"]);

[frequenzaFeedNum, frequenzaFeed, ~]  = dualCategoryMatrixInterpolation(T, Eta, voto1_5);

figure(14)
clf
barPlotRowNorm(frequenzaFeed{1:end-1,1:end-1}, voto1_5, Eta, {'Con quanta frequenza ti capitano nei "Per Te" o nel "Feed"','video o post del BookTok, BookTube o Bookstagram [%]'},0,'grouped');
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"14-Con quanta frequenza ti capitano nei feed video o post a tema libro-perc.pdf", '-dpdf')
table2latex(frequenzaFeed,char(savePath+"14-Con quanta frequenza ti capitano nei feed video o post a tema libro-perc.tex"))
table2latex(frequenzaFeedNum,char(savePath+"14-Con quanta frequenza ti capitano nei feed video o post a tema libro-clear.tex"))


%% Quanto pensi che il BookTok, Bookstagram, BookTube abbia influito sul tuo approccio alla lettura (15)
T = report(:, ["Eta", "Da1A5QuantoPensiCheIlBookTokBookstagramBookTubeAbbiaInfluitoSul"]);

[bookInfluenzaNum, bookInfluenza, ~]  = dualCategoryMatrixInterpolation(T, Eta, voto1_5);

figure(15)
clf
barPlotRowNorm(bookInfluenza{1:end-1,1:end-1}, voto1_5, Eta, {'Quanto pensi che il BookTok, Bookstagram, BookTube','abbia influito sul tuo approccio alla lettura [%]'},0,'grouped');
set(gcf,'Position',[0 0 800 600])
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"15-Quanto pensi che il BookTok, Bookstagram, BookTube abbia influito sul tuo approccio alla lettura-perc.pdf", '-dpdf')
table2latex(bookInfluenza,char(savePath+"15-Quanto pensi che il BookTok, Bookstagram, BookTube abbia influito sul tuo approccio alla lettura-perc.tex"))
table2latex(bookInfluenzaNum,char(savePath+"15-Quanto pensi che il BookTok, Bookstagram, BookTube abbia influito sul tuo approccio alla lettura-clear.tex"))

%% Prima di comprare un libro quanto ti basi sui pareri del BookTok, Booktube e Bookstagram (16)
T = report(:, ["Eta", "PrimaDiComprareUnLibroQuantoTiBasiSuiPareriDelBookTokBooktubeEB"]);
oldcats = {'1', '0'};
T.PrimaDiComprareUnLibroQuantoTiBasiSuiPareriDelBookTokBooktubeEB = mergecats(T.PrimaDiComprareUnLibroQuantoTiBasiSuiPareriDelBookTokBooktubeEB,oldcats);

[importanzaBookInfluenzerNum, importanzaBookInfluenzer, ~]  = dualCategoryMatrixInterpolation(T, Eta, voto1_5);

figure(16)
clf
barPlotRowNorm(importanzaBookInfluenzer{1:end-1,1:end-1}, voto1_5, Eta, {'Prima di comprare un libro quanto ti basi','BookTok, Booktube e Bookstagram [%]'},0,'grouped');
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"16-Prima di comprare un libro quanto ti basi sui pareri del BookTok, Booktube e Bookstagram-perc.pdf", '-dpdf')
table2latex(importanzaBookInfluenzer,char(savePath+"16-Prima di comprare un libro quanto ti basi sui pareri del BookTok, Booktube e Bookstagram-perc.tex"))
table2latex(importanzaBookInfluenzerNum,char(savePath+"16-Prima di comprare un libro quanto ti basi sui pareri del BookTok, Booktube e Bookstagram-clear.tex"))


%% Come scegli i libri da comprare (17)
T = report(:, ["Eta", "ComeScegliILibriDaComprarePuoiSelezionarePiDiUnaRisposta"]);

catList = [ "Leggo trame di libri finché non trovo quello che fa per me", ...
            "Consigli di amici", ...
            "Consigli di Bookinfluencer", ...
            "Mi faccio consigliare dal libraio", ...
            "Mi faccio ispirare dalla copertina"];
comeScegliLibriComprare = categorical(catList);
comeScegliLibriComprare = reordercats(comeScegliLibriComprare,catList);

[comeScegliNum, comeScegli, ~]  = dualCategoryMatrixInterpolation(T, Eta, comeScegliLibriComprare);
[comeSceglicut, comeScegliLibriComprareOrder] = tableSortCol(comeScegli, 'descend', comeScegliLibriComprare);

figure(17)
clf
comeScegliLibriComprareRename = renamecats(comeScegliLibriComprareOrder, "Leggo trame di libri finché non trovo quello che fa per me", "Leggo trame");
barPlotRowNorm(comeSceglicut, comeScegliLibriComprareRename, Eta, "Come scegli i libri da comprare [%]",3);
set(gcf,'Position',[0 0 800 600])
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"17-Come scegli i libri da comprare-perc.pdf", '-dpdf')
table2latex(comeScegli,char(savePath+"17-Come scegli i libri da comprare-perc.tex"))
table2latex(comeScegliNum,char(savePath+"17-Come scegli i libri da comprare-clear.tex"))

%% Compri libri che hanno sulla copertina scritto "fenomeno di BookTok" o "romanzo di wattpad" (18)
T = report(:, ["Eta", "CompriLibriCheHannoSullaCopertinaScrittofenomenoDiBookTokOroman"]);
currentCat = categorical(categories(T.CompriLibriCheHannoSullaCopertinaScrittofenomenoDiBookTokOroman));
[impattoCopertinaNum, impattoCopertina, ~]  = dualCategoryMatrixInterpolation(T, Eta, currentCat);

figure(18)
clf
barPlotRowNorm(impattoCopertina{1:end-1,1:end-1}, currentCat, Eta, {'Compri libri che hanno sulla copertina scritto','"Fenomeno di BookTok" o "Romanzo di Wattpad" [%]'},2);
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"18-Compri libri che hanno sulla copertina scritto fenomeno booktok o wattpad-perc.pdf", '-dpdf')
table2latex(impattoCopertina,char(savePath+"18-Compri libri che hanno sulla copertina scritto fenomeno booktok o wattpad-perc.tex"))
table2latex(impattoCopertinaNum,char(savePath+"18-Compri libri che hanno sulla copertina scritto fenomeno booktok o wattpad-clear.tex"))


%% Considera gli ultimi dodici mesi. Ti è capitato di comprare dei libri suggeriti da BookTok, BookTube o Bookstagram? (19)
T = report(:, ["Eta", "ConsideraGliUltimiDodiciMesiTiCapitatoDiComprareDeiLibriSuggeri"]);
[impattoCopertinaUltimoAnnoNum, impattoCopertinaUltimoAnno, ~]  = dualCategoryMatrixInterpolation(T, Eta, siNoCat);

figure(19)
clf
barPlotRowNorm(impattoCopertinaUltimoAnno{1:end-1,1:end-1}, siNoCat, Eta, {'Considera gli ultimi dodici mesi: ti è capitato di comprare dei libri','suggeriti da BookTok, BookTube o Bookstagram? [%]'},0);
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"19-Considera gli ultimi dodici mesi-Ti è capitato di comprare dei libri suggeriti da BookTok, BookTube o Bookstagram-perc.pdf", '-dpdf')
table2latex(impattoCopertinaUltimoAnno,char(savePath+"19-Considera gli ultimi dodici mesi-Ti è capitato di comprare dei libri suggeriti da BookTok, BookTube o Bookstagram-perc.tex"))
table2latex(impattoCopertinaUltimoAnnoNum,char(savePath+"19-Considera gli ultimi dodici mesi-Ti è capitato di comprare dei libri suggeriti da BookTok, BookTube o Bookstagram-clear.tex"))

%% Compri e leggi un libro anche se è stato definito "brutto" da un bookinfluencer che segui e stimi? (20)
T = report(:, ["Eta", "CompriELeggiUnLibroAncheSeStatoDefinitobruttoDaUnBookinfluencer"]);
[libroDefBruttoNum, libroDefBrutto, ~] = dualCategoryMatrixInterpolation(T, Eta, siNoCat);

figure(20)
clf
barPlotRowNorm(libroDefBrutto{1:end-1,1:end-1}, siNoCat, Eta, {'Compri e leggi un libro anche se è stato definito "Brutto"','da un Bookinfluencer che segui e stimi? [%]'},0);
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"20-Compri e leggi un libro anche se è stato definito brutto-perc.pdf", '-dpdf')
table2latex(libroDefBrutto,char(savePath+"20-Compri e leggi un libro anche se è stato definito brutto-perc.tex"))
table2latex(libroDefBruttoNum,char(savePath+"20-Compri e leggi un libro anche se è stato definito brutto-clear.tex"))

%% Durante la lettura di un libro cosa fai? (21)
report_filterId = ~isundefined(report.DuranteLaLetturaDiUnLibro);
T = report(report_filterId, ["Eta", "DuranteLaLetturaDiUnLibro"]);
catList = ["Utilizzo dei post-it per segnare delle frasi";"Scrivo sul libro le mie impressioni";"Utilizzo evidenziatori e sottolineo frasi";"Faccio le orecchiette alle pagine";"Utilizzo segnalibri"; "Nulla";"Altri"];
DuranteLaLetturaCat = categorical(catList);
% DuranteLaLetturaCat = reordercats(DuranteLaLetturaCat,catList);

[duranteLaLetturaNum, duranteLaLettura, ~] = dualCategoryMatrixInterpolation(T, Eta, DuranteLaLetturaCat);
[duranteLaLetturaCut, DuranteLaLetturaCatOrder] = tableSortCol(duranteLaLettura, 'descend', DuranteLaLetturaCat);

figure(21)
clf
barPlotRowNorm(duranteLaLetturaCut, DuranteLaLetturaCatOrder, Eta, 'Durante la lettura di un libro cosa fai? [%]',3);
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+"21-Durante la lettura di un libro cosa fai-perc.pdf", '-dpdf')
table2latex(duranteLaLettura,char(savePath+"21-Durante la lettura di un libro cosa fai-perc.tex"))
table2latex(duranteLaLetturaNum,char(savePath+"21-Durante la lettura di un libro cosa fai-clear.tex"))

%% Quanti libri compri se NON fai parte di una Community (22)
col = ["Eta", "QuantiLibriCompriInMediaInUnAnnoTraUsatiENuoviScrivereIlNumeroI"];
T = report(utentiNonParteComLib_Id, ["Eta", "QuantiLibriCompriInMediaInUnAnnoTraUsatiENuoviScrivereIlNumeroI"]);
hist3MultCategory(T, Eta, 10, 60, ["Quanti libri compri se NON FAI","parte di una Community[%]"],22)
view(65,30)
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'22-Quanti libri compri se NON fai parte di una Community-perc.pdf', '-dpdf')

%% Quanti libri compri se fai parte di una Community (23)
col = ["Eta", "QuantiLibriCompriInMediaInUnAnnoTraUsatiENuoviScrivereIlNumeroI"];
T = report(utentiParteComLib_Id, ["Eta", "QuantiLibriCompriInMediaInUnAnnoTraUsatiENuoviScrivereIlNumeroI"]);
hist3MultCategory(T, Eta, 10, 60, ["Quanti libri compri se fai","parte di una Community[%]"],23)
view(65,30)
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'23-Quanti libri compri se fai parte di una Community-perc.pdf', '-dpdf')

%% Tra gli appartenenti a una Community, sei un bookinfluencer? (24)
T = report(utentiParteComLib_Id, "UsiUnoDiQuestiAccountPerParlareDiLibriseiUnBookinfluencer");

figure(24)
pie(T.UsiUnoDiQuestiAccountPerParlareDiLibriseiUnBookinfluencer, [1,0])
title(["Tra gli appartenenti a una Community,","sei un Bookinfluencer?"])
set(gcf,'PaperOrientation','landscape');
print(gcf,'-vector','-bestfit', savePath+'24-Tra gli appartenenti a una Community, sei un bookinfluencer.pdf', '-dpdf')




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

function barPlotColNorm(tableMatrix, xNameCategory, subBarCategory, titleString, fitLevel,stylePlot)
if ~exist('stylePlot','var')
    % il secondo parametro non esiste, so default it to something
    stylePlot = 'stacked';
end
bar(xNameCategory,tableMatrix,stylePlot);
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

function colNormTopTextBar(tableMatrix, order)
Y = tableMatrix{1:end-1,"SumRows"}';
if ~exist('order','var')
    % il secondo parametro non esiste, so default it to something
    dataPlotOrder = Y;
else
    dataPlotOrder(grp2idx(order)) = Y;
end
text(1:length(Y),dataPlotOrder,num2str(dataPlotOrder'),'vert','bottom','horiz','center');
end

function barPlotRowNorm(tableMatrix, xNameCategory, subBarCategory, titleString, fitLevel,stylePlot)
if ~exist('stylePlot','var')
    % il secondo parametro non esiste, so default it to something
    stylePlot = 'stacked';
end
bar(xNameCategory,tableMatrix,stylePlot);
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

function rowNormTopTextBar(tableMatrix, order)
Y = tableMatrix{"SumCols",1:end-1};
if ~exist('order','var')
    % il secondo parametro non esiste, so default it to something
    dataPlotOrder = Y;
else
    dataPlotOrder(grp2idx(order)) = Y;
end
text(1:length(Y),dataPlotOrder,num2str(dataPlotOrder'),'vert','bottom','horiz','center');
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

% Reorder rows of table based on sum of rows
function [matrixCut, newRowlOrder] = tableSortRow(tableOriginal, sortType, rowCategory)
[sortedY, sortOrder] = sort(tableOriginal{1:end-1,"SumRows"}, sortType);
newRowlOrder = reordercats(rowCategory, string(rowCategory(sortOrder)));
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

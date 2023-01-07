
% Komut penceresindeki tüm metni temizle
% Tüm açık grafikleri kapat
close all
% "True.csv" dosyasından bir tablo oku ve bu tablonun değerini "trueTable" değişkenine ata
trueTable = readtable('True.csv');
% "Fake.csv" dosyasından bir tablo oku ve bu tablonun değerini "fakeTable" değişkenine ata
fakeTable = readtable('Fake.csv');

% "trueTable" tablosunun sütun adlarını bir dizi olarak al ve bu dizinin değerini "trueColumnNames" değişkenine ata
trueColumnNames = trueTable.Properties.VariableNames;
% "fakeTable" tablosunun sütun adlarını bir dizi olarak al ve bu dizinin değerini "fakeColumnNames" değişkenine ata
fakeColumnNames = fakeTable.Properties.VariableNames;
% "trueTable" tablosuna bir sütun ekle ve bu sütunun tüm hücrelerine 1 değerini ata. Sütunun adı "class" olacak şekilde ayarla ve bu tablonun değerini "trueTable1" değişkenine ata
trueTable1 = addvars(trueTable, ones(height(trueTable),1), 'NewVariableNames', 'class');
% "fakeTable" tablosuna bir sütun ekle ve bu sütunun tüm hücrelerine 0 değerini ata. Sütunun adı "class" olacak şekilde ayarla ve bu tablonun değerini "fakeTable1" değişkenine ata
fakeTable1 = addvars(fakeTable, zeros(height(fakeTable),1), 'NewVariableNames', 'class');
% "trueTable1" tablosunun ilk 10 satırını görüntüle
head(trueTable1 ,10)
% "fakeTable1" tablosunun ilk 10 satırını görüntüle
head(fakeTable1 ,10)
% "trueTable1" ve "fakeTable1" tablosunu yatay olarak birleştir ve bu tablonun değerini "df" değişkenine ata
df = vertcat(trueTable1, fakeTable1);

% Tüm verileri birleştirilmiş olan "df" tablosundaki her bir "class" sütununun eleman sayısını say
counts = grpstats(df, 'class', 'numel');
% "df" tablosundaki tüm öğeleri birleştir
df = unique(df);
% Tüm verileri birleştirilmiş olan "df" tablosundaki her bir "class" sütununun eleman sayısını say
counts = grpstats(df, 'class', 'numel');

%%
% "subject" sütununu kategorik veriye çevir ve
% haber konu sınıf dağılımını gösteren bir histogram oluştur.
df.subject = categorical(df.subject);
figure
histogram(df.subject)
xlabel("Sınıf") % X ekseni etiketi
ylabel("Frekans") % Y ekseni etiketi
title("Konu Sınıf Dağılımı") % Grafik başlığı

%% Bir grafik oluştur
figure();
% Sınıf 0 için kırmızı renkli bir bar çiz ve bu barın etiketini "Fake" olarak ayarla
bar(0, sum(df.class==0), 'FaceColor', [1 0 0],'DisplayName', 'Fake');
% Grafiğe bir bar daha ekle
hold on;
% Sınıf 1 için yeşil renkli bir bar çiz ve bu barın etiketini "True" olarak ayarla
bar(1, sum(df.class==1), 'FaceColor', [0 1 0],'DisplayName', 'True');
% Grafiğin x eksenine "Class" etiketi ekle
xlabel("Class")
% Grafiğin y eksenine "Frequency" etiketi ekle
ylabel("Frequency")
% Grafiğe bir başlık ekle
title("Class Distribution Of class")
% Grafiğe bir lejant ekle
legend('Location', 'northwest');
%%
% 'subject' sütunundaki her kategorideki tekrar sayısını say
counts = histcounts(df.subject);
% Sayıların bar grafiğini oluştur
figure();
bar(counts, 'FaceColor', [0.5, 0.5, 0.5], 'DisplayName', 'Haber');
% 'class' sütunundaki kategorilere göre çubukları farklı renklere ayır
hold on
uniqueClasses = unique(df.class); % Farklı 'class' değerlerini al
subjects = unique(df.subject); % Farklı 'subject' değerlerini al
xticklabels(subjects); % Eksen etiketlerini 'subject' değerlerine ayarla

colors = lines(length(uniqueClasses)); % Farklı renkler oluştur
for i = 1:length(uniqueClasses)
    % 'class' sütunundaki her bir değere ait verileri seç
    classData = df(df.class == uniqueClasses(i), :);    
    % Seçilen verilerdeki 'subject' sütunundaki tekrar sayılarını say
    classCounts = histcounts(classData.subject);    
    % 'subject' sütunundaki tekrar sayılarını bar grafiğinde göster
    bar(classCounts, 'FaceColor', colors(i, :),'DisplayName', 'Yalan');
end
% Eksenleri etiketler
xlabel("Sınıf")
ylabel("Sıklık")
title("Konu Sınıf Dağılımı")
% Grafikte bir açıklama ekle
legend('Location', 'northwest');
%%
% "df" tablosundaki "text" sütunundaki boş hücreleri bul ve bu hücrelerin dizinini "idxEmpty" değişkenine ata
idxEmpty = strlength(df.text) == 0:1;
% "df" tablosundaki "idxEmpty" dizininde belirtilen satırları sil
df(idxEmpty, :) = [];
%%
% "subject" sütununu kategorik değişken olarak ayarla
df.subject = categorical(df.subject);
% Bir grafik oluştur
f = figure;
% Grafiğin genişliğini 3 katına çıkar
f.Position(3) = 1.5*f.Position(3);
% "subject" sütunundaki verileri bir histogramda göster
h = histogram(df.subject);
% X eksenini "Various findings" (Çeşitli bulgular) olarak etiketle
xlabel ("Various findings")
% Y eksenini "Range" (Aralık) olarak etiketle
ylabel ("Range")
% Grafiğin başlığını "finding Distribution" (Bulgu dağılımı) olarak ayarla
title ("finding Distribution")
% Bulguların frekans sayılarını al
findingCounts = h.BinCounts;
% Bulguların isimlerini al
findingNames= h.Values;
% On veya daha az gözlemlenen bulguları bul
idxLowCounts = findingCounts < 10;
% Bu bulguları al
infrequentfindings = findingNames(idxLowCounts);
% Kullanılmayan kategorileri kaldır
idxInfrequent = ismember(df.class,infrequentfindings);
df(idxInfrequent, :)= [];
% "subject" sütunundaki kategorileri kaldır
df.subject = removecats(df.subject);
% Verileri eğitim verisi ve test verisi olarak böl
cvp = cvpartition(df.class, 'Holdout', 0.3); % 30% test için
dataTrain = df(training (cvp), :);
dataHeldOut= df(test (cvp), :);
% Test verisini doğrulama verisi ve test verisi olarak böl
cvp = cvpartition (dataHeldOut.subject,'HoldOut', 0.5);
dataValidation = dataHeldOut(training (cvp),:);
dataTest = dataHeldOut(test (cvp),:);
% Bölünmüş tablonun metin verilerini ve etiketlerini ayıkla
textDataTrain = dataTrain.subject;
textDataValidation = dataValidation.subject;
textDataTest = dataTest.subject;
YTrain = dataTrain.class;
YValidation = dataValidation.class;
YTest = dataTest.class;
% "YTest" değişkenini kaydet
save YTest YTest
%% Eğitim verisi metin verilerini kelime bulutu olarak görüntüle
figure
wordcloud(textDataTrain);
% Grafiğin başlığını 
title ("finding Distribution in Cloud")

%%
% Başlık sütununu kategorik verilere dönüştürün ve
% haber başlıklarında sık kullanılan kelimeleri gösteren kelime bulutu oluşturun.
C = categorical(df.title);
figure
wordcloud(C);
title("News Title Word Cloud")

%% Gerçek ve Yalan Haberlerin Kelime Bulutları
% Yalan haberler veri tablosundan haber sütununu çıkar
text = fakeTable1.text;
% Metni bir dizeye dönüştür
text = string(text);
% Metni kullanarak bir kelime bulutu oluştur
wordcloud = wordcloud(text);
% Kelime bulutunun genişliğini, yüksekliğini ve arka plan rengini ayarla
wordcloud.Width = 3000;
wordcloud.Height = 2000;
wordcloud.BackgroundColor = 'black';
% Kelime bulutunda dikkate alınmayacak durdurma kelimelerini ayarla
wordcloud.Stopwords = stopwords;
% Kelime bulutunu oluştur
wordcloud.generate();
% Yeni bir çizim oluştur
fig = figure;
% Çizimin boyutunu ve rengini ayarla
fig.Position = [0 0 40 30];
fig.Color = 'k';
% Çizimde kelime bulutunu göster
imshow(wordcloud);
% Eksenleri gizle
axis off
% Çizimin düzenini ayarla
tightfig
% Çizimi göster
show(fig)
%%
% Gerçek haberler veri tablosundan haber sütununu çıkar
text = trueTable1.text;
% Metni bir dizeye dönüştür
text = string(text);
% Metni kullanarak bir kelime bulutu oluştur
wordcloud = wordcloud(text);
% Kelime bulutunun genişliğini, yüksekliğini ve arka plan rengini ayarla
wordcloud.Width = 3000;
wordcloud.Height = 2000;
wordcloud.BackgroundColor = 'black';
% Kelime bulutunda dikkate alınmayacak durdurma kelimelerini ayarla
wordcloud.Stopwords = stopwords;
% Kelime bulutunu oluştur
wordcloud.generate();
% Yeni bir çizim oluştur
fig = figure;
% Çizimin boyutunu ve rengini ayarla
fig.Position = [0 0 40 30];
fig.Color = 'k';
% Çizimde kelime bulutunu göster
imshow(wordcloud);
% Eksenleri gizle
axis off
% Çizimin düzenini ayarla
tightfig
% Çizimi göster
show(fig);

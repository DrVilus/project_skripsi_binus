import 'package:project_skripsi/Models/BuildGuideModel.dart';

class BuildGuideVariablePage{

  static BuildGuideModelListWithTitle buildGuideMainList = BuildGuideModelListWithTitle("Build Guide", buildGuideList);

  static List<dynamic> buildGuideList = [
    BuildGuideModel("Merencanakan budget dan speks", '''
    Pertama-tama sebelum memilih part yang diinginkan, sebaiknya anda menentukan kisaran spesifikasi dari komputer yang diinginkan serta budget maksimal berdasarkan kebutuhan.Untuk spesifikasi, pada umumnya sebagian besar orang akan menentukan lebih dahulu penggunaan pc dan menentukan garis besar dari spesifikasi pc yang ingin dirakit seperti processor, GPU/VGA unit, jumlah RAM, dan jumlah storage, sisanya pada umumnya orang akan menyesuaikan sisa perangkat yang diperlukan. Sebagai generalisasi, budget untuk hanya keperluan kantor dan pekerjaan ringan yang tidak memerlukan tenaga komputasi dan grafis tinggi, budget yang diperlukan biasanya dapat di bawah Rp. 5.000.000. Untuk gaming low ke mid-high range dan pekerjaan yang mencakup energi komputasi dan grafis yang lebih tinggi dapat memakan budget dengan kisaran antara Rp 5.000.000 – Rp.20.000.000 tergantung seberapa kuat spesifikasi komputer dan part spesifik yang diinginkan. Terakhir untuk spek high-end dengan perangkat-perangkat keluaran terbaru bisa memakan lebih dari Rp. 20.000.000. Tentu saja sebagai generalisasi umum harga dapat berfluktuasi tergantung terhadap spesifikasi anda, oleh karena itu memasang budget sangatlah penting agar harga total dari pc yang dirakit tidak semakin naik.
    ''', ""),
//////////////////////
    BuildGuideModelListWithTitle("Mengenal Perangkat yang diperlukan", [
      BuildGuideModel("Processor/CPU", '''
      Sumber : https://www.hwcooling.net/en/core-i5-12400-with-ddr4-test-meet-the-fresh-bestseller/Central  
      Processing Unit atau processor singkatnya adalah “otak” dari sebuah PC.  Untuk processor dua pemain utama yang ada di pasar pc konsumen adalah intel dan AMD. Masing-masing manufaktur memiliki beberapa macam lini series untuk processor mereka, dimana semakin tinggi tingkatan seri produk dan semakin mahal processor akan memiliki kekuatan komputasi yang semakin tinggi juga. Seiring tahun semakin teknologi berkembang maka processor dari manufaktur tersebut akan dibuat ulang dengan menggunakan teknologi terbaru dan meningkatkan performa oleh karena itu processor memiliki hal yang disebut generasi dimana semakin tinggi generasi processor semakin baru dan semakin kuat processor tersebut.
      ''', "assets/img/cpuPicture.png"),

      BuildGuideModel("Motherboard", ''' 
      sumber:https://www.msi.com/Landing/amd-ryzen-b550-motherboard
      Motherboard dapat didefinisikan sebagai circuit board yang menyambungkan seluruh komponen dan perangkat dari pc sehingga masing-masing hardware dapat saling berkomunikasi. Untuk memilih motherboard sangat penting untuk mengetahui dan memilih motherboard mana yang dapat mendukung processor yang anda pilih, baik intel atau AMD processor serta tipe socket yang diperlukan oleh processor tersebut. Setelah itu anda dapat menyesuaikan chipset dan performa motherboard lainnya. Motherboard biasanya terdapat dalam 3 form factor dari terbesar ke terkecil yaitu ATX, Micro-ATX, dan Mini-ATX. PC standar biasanya menggunakan form factor micro-atx dimana motherboard memiliki opsi dan kekuatan yang cukup untuk menjalankan komputer, sementara untuk PC high-end anda dapat menggunakan ATX motherboard. Dan untuk Mini-ATX biasanya form factor tersebut digunakan untuk membuat pc dengan ukuran yang sangat compact.

      ''', "assets/img/motherboardPicture.png"),

      BuildGuideModel("VGA/GPU",'''
      Sumber : https://www.msi.com/Graphics-Card/GeForce-RTX-3060-GAMING-X-12G
      Graphics Processing Unit adalah perangkat yang memberikan tenaga bagi komputer untuk melakukan komputasi grafis. Penggunaan GPU dapat dianggap opsional karena terdapat versi processor yang memiliki integrated Graphics Processing Unit dimana untuk processor modern sudah memiliki kekuatan komputasi grafis yang cukup kuat sehingga anda tidak perlu membeli GPU tersendiri lagi kecuali jika anda ingin menggunakan untuk gaming atau melakukan pekerjaan yang memerlukan komputasi grafis yang sangat ekstensif
      ''',"assets/img/gpuPicture.png"),

      BuildGuideModel("RAM",'''
      Sumber : https://www.corsair.com/eu/en/Categories/Products/Memory/VENGEANCE-LPX/p/CMK16GX4M2A2666C16
      Random Access Memory menyimpan memori jangka pendek yang digunakan untuk mengakses dan memproses data dari operasi komputer yang tersimpan sementara dalam RAM.  Untuk komputer modern, dikarenakan perkembangan teknologi software disarankan seminimalnya untuk memiliki 4GB RAM. 8GB merupakan standar untuk sebagian besar operasi dan gaming, untuk operasi yang lebih berat serta gaming yang optimal 16GB merupakan jumlah RAM yang cocok, namun anda dapat menambah lebih lagi sampai ke paling tinggi biasanya 128 GB namun pada umumnya 32GB sudah melebihi kebutuhan pengguna. Terakhir pastikan RAM yang anda pilih didukung oleh motherboard yang anda pilih.

      ''',"assets/img/ramPicture.png"),

      BuildGuideModel("Storage",'''
      Sumber : https://www.klevv.com/ken/products_details/ssd/Klevv_NEO_n500M2
      Perangkat yang menyimpan data permanen untuk PC anda. Untuk solusi storage anda masih bisa menggunakan Hard Disk Drives (HDD) untuk komputer anda, tetapi era komputer modern dengan adanya Solid State Drive (SSD) sebagai storage yang lebih cepat dan tahan lama menjadi pilihan utama dibanding HDD, namun SSD memakan biaya lebih besar.

      ''',"assets/img/storagePicture.png"),
      BuildGuideModel("PSU",'''
      Sumber: https://www.antec.com/product/power/hcg-gold750
Power Supply Unit adalah perangkat yang memberikan pc anda aliran listrik agar dapat berfungsi. Pastikan Wattage dari PSU yang anda pilih dapat mendukung keperluan tenaga dari build pc anda berdasarkan komponen-komponen perangkat yang anda pilih seperti GPU.
PSU dapat dibedakan menjadi 3 jenis menurut cara pemasangan kabelnya, yaitu
-	Fully Modular : tidak ada kabel yang terhubung secara permanen kepada PSU
-	Semi Modular :beberapa kabel ada yang terhubung secara permanen kepada PSU seperti ATX dan CPU power
-	Non-Modular : Semua kabel terhubung secara permanen dan tak dapat dilepas

      ''',"assets/img/psuPicture.png"),

      BuildGuideModel("Cooling",'''
      Sumber: https://www.thermaltake.com/contac-9-cpu-cooler.html
Ketika pc anda bekerja komponen perangkat pc anda pasti akan menghasilkan energi panas. Biasanya sebagian casing dan CPU memiliki cooling bawaan untuk meregulasi temperatur dan airflow dari pc anda namun untuk build pc yang berperforma tinggi biasanya akan menghasilkan panas yang lebih tinggi sehingga untuk mengatur temperatur biasanya anda memerlukan untuk menggunakan atau menambah cpu cooling atau casing fan untuk menjaga agar pc anda tidak memiliki temperatur terlalu tinggi.

      ''',"assets/img/coolerPicture.png"),

      BuildGuideModel("Casing",'''
      Sumber: https://nzxt.com/collection/h710
      Casing adalah perangkat yang menyimpan dan merangkap seluruh perangkat pc, dan menjadi tampilan luar pc anda. Casing memiliki jumlah variasi yang sangat banyak di pasar perangkat pc, anda dapat memilih casing pc sesuai dengan preferensi anda dari tampilan,berat, material, dan ukuran pc. Namun untuk memilih ukuran pc anda sebaiknya memeriksa terlebih dahulu form factor motherboard apa yang dapat dipasang di dalam casing tersebut. Casing untuk motherboard ATX pasti dapat memuat form factor lainnya juga namun biasanya ukuran casing tersebut relatif lebih besar, dan untuk yang memuat form factor Micro-ATX tidak akan dapat memuat motherboard ATX tapi dapat memuat mini-ATX.

      ''',"assets/img/casePicture.png"),

      BuildGuideModel("Aksesoris",'''
      Selain komponen-komponen yang sudah disebutkan, itu untuk menggunakan pc yang dirakit, anda juga harus menginstall operating system agar pc anda dapat dipakai dan tidak lupa perangkat-perangkat seperti monitor untuk menampilkan layar serta mouse dan keyboard untuk melakukan input terhadap pc anda.
      ''',"")
    ]),
//////////////////
    BuildGuideModel("Memasang CPU ke motherboard",
        '''
1.       Keluarkan motherboard dari kemasan dan letakkan di atas permukaan tempat kerja anda.
2.       Temukan soket CPU, kemudian buka soket dengan menggunakan tuas logam yang ada di samping loket CPU dengan menekan tuas secara perlahan dan menarik tuas menjauh dari soket, kemudian anda dapat mengangkat tuas tersebut untuk membuka soket.
3.       Buka CPU dari kemasan dengan berhati-hati. Perlu diketahui bahwa CPU dan soket CPU sangat rentan terhadap kerusakan fisik, dan jangan pernah memegang pin pada bagian bawah chip karena dapat menyebabkan kotoran untuk menempel, usahakan untuk memegang cpu pada bagian tepi.
4.       Pasang CPU dengan menjajarkan terhadap indikator yang terdapat di soket. Pastikan untuk memasangnya dengan perlahan dan anda tidak perlu menekan cpu tersebut.
5.       Tarik kembali tuas logam untuk menutup soket CPU
        ''', ""),
    
    BuildGuideModel("Memasang Cooling CPU", '''
    Untuk proses memasang cooling CPU, karena terdapat berbagai macam jenis cooling CPU untuk instruksi spesifik sebaiknya anda mengikuti langsung instruksi yang disertakan dalam kemasan cooling CPU. Hal yang perlu diperhatikan adalah pemasangan thermal paste ke CPU. Beberapa cooling sudah dipasangkan thermal paste sebelumnya, namun jika belum anda perlu memasangkan sendiri. Anda cukup meneteskan setitik kecil seukuran beras dari thermal paste ke tengah CPU, kemudian anda dapat meletakkan cooling ke CPU dan thermal paste akan menyebar dengan sendirinya.

    ''', ""),
    
    BuildGuideModel("Memasang RAM", '''
1.	Pertama-tama, pastikan DDR RAM yang digunakan sesuai dengan spesifikasi motherboard dan jika memasang lebih dari satu pasang pastikan RAM yang dipasang memiliki jumlah memori yang sama.
2.	Temukan slot RAM pada motherboard 
3.	Tekan tuas pada pinggir ujung slot RAM dan sejajarkan RAM dengan lubang slot.
4.	Tekan RAM dari kedua ujung sampai terdengar suara klik.

Jika anda tidak menggunakan seluruh slot ram pastikan gunakan slot yang paling jauh dari CPU terlebih dahulu.
''', ""),
    
    BuildGuideModel("Memasang PSU ke casing", '''
1.	Periksa casing terlebih dahulu dan cari dimana PSU seharusnya dipasang. Rencanakan posisi PSU dengan mengarahkan kipas PSU ke tempat ventilasi, namun pada umumnya PSU diarahkan menghadap ke atas.
2.	Masukkan PSU ke mounting area untuk PSU.
3.	Pasang PSU ke casing menggunakan sekrup yang disertakan pada PSU.
4.	Pasang dan kelola kabel PSU.
''', ""),
    
    BuildGuideModel("Memasang Motherboard ke casing", '''
1.	Pasang pelindung I/O ke bagian belakang casing yang terlihat terpotong  jika pelindung I/O tidak terpasang terlebih dahulu ke motherboard
2.	Posisikan motherboard sejajar dengan pelindung I/O dengan bagian standoff untuk motherboard
3.	Pasang standoff 
4.	Posisikan motherboard pada standoff
5.	Pasang sekrup untuk menempatkan motherboard
''', ""),

    BuildGuideModel("Memasang Storage", '''
Jika anda menggunakan SSD M.2, ikuti arahan berikut.
1.	Temukan slot M.2 pada motherboard.
2.	Lepaskan sekrup yang terdapat pada slot M.2
3.	Geser SSD perlahan-lahan ke dalam slot.
4.	Ketika sudah benar-benar terpasang pasang kembali sekrup

Jika anda menggunakan HDD, ikuti arahan berikut.
1.	Ambil HDD bracket dari drive bay
2.	Geser HDD ke dalam bracket
3.	Amankan HDD menggunakan sistem mekanisme yang digunakan bracket
4.	Masukkan kembali bracket kedalam drive bay
    ''', ""),
    
    BuildGuideModel("Memasangkan kabel-kabel", '''
Untuk Motherboard, pasang kabel ATX 24 pin dan CPU 8 pin PSU melalui potongan-potongan dan lubang yang tersedia di bagian backplate ke port yang tersedia pada motherboard

Untuk bagian storage, Pasang konektor SATA dari PSU ke drive bay atau mount yang tersedia.
Jika menggunakan storage drive, hubungkan ke motherboard dengan menggunakan kabel data SATA KE port SATA pada motherboard.

Kemudian, hubungkan panel I/O bagian depan dan konektor lainnya ke motherboard menggunakan instruksi yang disediakan oleh motherboard mengenai pin dan kabel mana saja yang perlu dihubungkan.
''', ""),

    BuildGuideModel("Menambah casing fan (optional)", '''
    Biasanya untuk mayoritas case menyediakan sejumlah kipas gratis bawaan yang dapat digunakan sebagai exhaust. Namun jika anda ingin menggunakan PC high end ada baiknya anda menambah atau menggantikan casing fan yang tersedia dengan yang berperforma tinggi untuk menjaga temperatur tetap normal. Pastikan berapa jumlah kipas yang didukung oleh casing terlebih dahulu dan tambah secukup mungkin. Untuk airflow yang optimal pastikan  air flow exhaust tidak lebih cepat daripada intake agar tidak terjadi negative air pressure yang dapat menyebabkan udara dingin dikeluarkan terlalu cepat dan debu lebih cepat mengumpul.
''', ""),

    BuildGuideModel("Memasang GPU (optional)", '''
    Jika anda ingin menanggunakan GPU selain iGPU yang terdapat pada CPU ikuti langkah berikut
1.	Temukan slot PCIe x16 pada motherboard anda yang ingin anda pasangkan GPU
2.	Lepaskan sekrup pada case bracket untuk pci pada casing dimana anda ingin memasang GPU.
3.	Pastikan slot untuk GPU card pada motherboard sudah terbuka
4.	Sejajarkan GPU dengan PCIe slot lalu masukkan dan dorong perlahan ke dalam slot sampai terdengar suara klik.
5.	Kencangkan bagian belakang casing dengan GPU untuk mengamankan posisinya
6.	Pasang kabel GPU ke PSU jika diperlukan

    ''', ""),
    
    BuildGuideModel("Penutupan Casing", '''
    Rapikan pengaturan kabel dan Tutup serta kencangkan bagian-bagian casing dengan semua sekrup yang diperlukan sampai casing tertutup dengan sempurna. Setelah itu anda dapat memasangkan kabel tenaga ke PSU dan dihubungkan ke stopkontak listrik. Setelah itu anda bisa dapat menyalakan PC anda. Namun jangan lupa untuk menggunakan PC anda memerlukan peripheral-peripheral terlebih dahulu dan menginstall sistem operasi untuk PC anda.
    ''', "")

    
  ];
}
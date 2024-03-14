class Banner_Model {
  String dicconst;
  String image;

  Banner_Model({required this.dicconst, required this.image});

  static List<Banner_Model> getBanner() {
    List<Banner_Model> Bannerlist = [];
    Bannerlist.add(
        Banner_Model(dicconst: '60% OFF', image: 'asset/banner.jpeg'));
    Bannerlist.add(
        Banner_Model(dicconst: '50% OFF', image: 'asset/banner1.jpg'));
    Bannerlist.add(
        Banner_Model(dicconst: '40% OFF', image: 'asset/banner2.webp'));
    return Bannerlist;
  }
}

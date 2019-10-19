class Post {

  static const int POST_IMAGE_COUNT = 11;

  int id = -1;
  double likes;
  int createdAt;
  int image;

  Post.toDb(this.likes, this.createdAt, this.image);

  Post.fromDb(this.id, this.likes, this.createdAt, this.image);

}
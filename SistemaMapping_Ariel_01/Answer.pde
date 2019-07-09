//class Answer {
//  String [] answers;
//  int [] ids;
//  Answer(String a, String b, String c, int a_id, int b_id, int c_id) {
//    answers = new String[3];
//    ids = new int[3];
//    answers[0] = a;
//    answers[1] = b;
//    answers[2] = c;
//    ids[0] = a_id;
//    ids[1] = b_id;
//    ids[2] = c_id;
//  }


//}


class Answer {
  String  txt;
  int  id;
  Answer(String s, int i) {
    txt = s;
    id = i;
  }
  
  String getText(){
  return txt;
  }
  
}

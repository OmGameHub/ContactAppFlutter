class MyContact 
{
  int _id;
  String _name;
  String _number;
  String _email;

  MyContact(this._name, this._number, [this._email]); 

  MyContact.withId(this._id, this._name, this._number, [this._email]); 

  int get id => _id;
  
  String get name => _name;

  String  get number => _number;

  String get email => _email;

  set name(String newName)
  {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set number(String newNumber)
  {
    this._number = newNumber;
  }

  set email(String newEmail)
  {
    if (newEmail.length <= 255) {
      this._email = newEmail;
    }
  }

  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['_id'] = this._id;
    }

    map['name'] = this._name;
    map['number'] = this._number;
    map['email'] = this._email;

    return map;
  }

  MyContact.fromMapObject(Map<String, dynamic> map)
  {
    this._id = map['_id'];
    this._name = map['name'];
    this._number = map['number'];
    this._email = map['email'];
  }
}
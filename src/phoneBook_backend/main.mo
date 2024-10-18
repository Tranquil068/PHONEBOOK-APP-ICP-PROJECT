import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";


actor PhoneBook{


  /**
   * Types
   */
  // The type of a user identifier.
  private type detailsId = Nat32;

  // The type of a user.
  public type details = {
    firstName :Text;
    lastName :Text;
    number:Nat;
  };

  /**
   * Application State
   */

 
  // The user data store.
  private stable var contacts : Trie.Trie<detailsId, details> = Trie.empty();

  /**
   * High-Level API
   */

  // ID
   stable var iden:detailsId = 0;


  // Read all contacts data
  public query func ReadAll() : async [details] {
    let array = Trie.toArray<detailsId,details,details>(
  contacts,
  func (k, v) = v
);
    array;
  };


 // Create a contact.
  public func createUser(user : details) : async detailsId {
   
    contacts := Trie.replace(
      contacts,
      key(iden),
      Nat32.equal,
      ?user,
    ).0;

    iden += 512;
    return iden;
  };

  // Read a contact.
  public query func readContact(user_id : Nat) : async ?details {
     let userId = Nat32.fromNat(user_id);
    let result = Trie.find(contacts, key(userId), Nat32.equal);
    return result;
  };

  // Update a contact.
  public func updateUser(user_Id : Nat, user : details) : async Bool {
    let userId = Nat32.fromNat(user_Id);
    let result = Trie.find(contacts, key(userId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      contacts := Trie.replace(
        contacts,
        key(userId),
        Nat32.equal,
        ?user,
      ).0;
    };
    return exists;
  };

  // Delete a contact.
  public func deleteUser(user_id : Nat) : async Bool {
    let userId = Nat32.fromNat(user_id);
    let result = Trie.find(contacts, key(userId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      contacts := Trie.replace(
        contacts,
        key(userId),
        Nat32.equal,
        null,
      ).0;
    };
    return exists;
  };

  /**
   * Utilities
   */
  // Create a trie key from a user identifier.
  private func key(x : detailsId) : Trie.Key<detailsId> {
    return { hash = x; key = x };
  }
}

abstract class AddVocabEvent {}

class AddVocabCamEvent extends AddVocabEvent {}

class EditableEvent extends AddVocabEvent {}

class ReorderEvent extends AddVocabEvent {}

class SwapEvent extends AddVocabEvent {}

class CropEvent extends AddVocabEvent {}
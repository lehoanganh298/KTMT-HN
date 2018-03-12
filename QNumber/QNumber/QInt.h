class QInt {
private:
	int arr[4]; // 4 int = 16 byte
public:
	void ScanQInt();
	void PrintQInt();

	bool * DecToBin(QInt x);
	QInt BinToDec(bool *bit);
	char *BinToHex(bool *bit);
	char *DecToHex(QInt x);

	QInt operator + (QInt a);
	QInt operator - (QInt a);
	QInt operator * (QInt a);
	QInt operator / (QInt a);
};

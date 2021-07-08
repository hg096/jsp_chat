package evaluation;

public class EvaluationDTO {
	int evaluationID;
	String userID;
	String purchaseName;
	String manufacturer;
	int purchaseYear;
	int purchaseMonth;
	String categories;
	String evaluationTitle;
	String evaluationContent;
	double price;
	String SatisfactionScore;
	String size;
	String qualityScore;
	int likeCount;

	public int getEvaluationID() {
		return evaluationID;
	}

	public void setEvaluationID(int evaluationID) {
		this.evaluationID = evaluationID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getPurchaseName() {
		return purchaseName;
	}

	public void setPurchaseName(String purchaseName) {
		this.purchaseName = purchaseName;
	}

	public String getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}

	public int getPurchaseYear() {
		return purchaseYear;
	}

	public void setPurchaseYear(int purchaseYear) {
		this.purchaseYear = purchaseYear;
	}

	public int getPurchaseMonth() {
		return purchaseMonth;
	}

	public void setPurchaseMonth(int purchaseMonth) {
		this.purchaseMonth = purchaseMonth;
	}

	public String getCategories() {
		return categories;
	}

	public void setCategories(String categories) {
		this.categories = categories;
	}

	public String getEvaluationTitle() {
		return evaluationTitle;
	}

	public void setEvaluationTitle(String evaluationTitle) {
		this.evaluationTitle = evaluationTitle;
	}

	public String getEvaluationContent() {
		return evaluationContent;
	}

	public void setEvaluationContent(String evaluationContent) {
		this.evaluationContent = evaluationContent;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getSatisfactionScore() {
		return SatisfactionScore;
	}

	public void setSatisfactionScore(String satisfactionScore) {
		SatisfactionScore = satisfactionScore;
	}

	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}

	public String getQualityScore() {
		return qualityScore;
	}

	public void setQualityScore(String qualityScore) {
		this.qualityScore = qualityScore;
	}

	public int getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}

	public EvaluationDTO(int evaluationID, String userID, String purchaseName, String manufacturer,
			int purchaseYear, int purchaseMonth, String categories, String evaluationTitle,
			String evaluationContent, double price, String SatisfactionScore, String size,
			String qualityScore, int likeCount) {
		super();
		this.evaluationID = evaluationID;
		this.userID = userID;
		this.purchaseName = purchaseName;
		this.manufacturer = manufacturer;
		this.purchaseYear = purchaseYear;
		this.purchaseMonth = purchaseMonth;
		this.categories = categories;
		this.evaluationTitle = evaluationTitle;
		this.evaluationContent = evaluationContent;
		this.price = price;
		this.SatisfactionScore = SatisfactionScore;
		this.size = size;
		this.qualityScore = qualityScore;
		this.likeCount = likeCount;
	}

}

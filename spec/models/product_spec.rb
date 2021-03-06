describe Product, type: :model do
  let(:product) { create(:product) }

  describe 'factory built record' do
    it 'atteches a file' do
      create(:image, owner: product)
      expect(product.images.count).to be(1)
    end
  end
end

describe Image, type: :model do
  let(:product) { create(:product) }
  let(:product2) { create(:product) }

  describe 'validates before saving' do
    it 'should not be allowed to create images with the same order for the same owner' do
      create(:image, owner: product, url: 'some_url', order: 0)
      expect(build(:image, owner: product, order: 0)).to have(1).error_on(:order)
    end

    it 'should not be allowed to create images with the same name for the same owner' do
      create(:image, owner: product, name: 'same')
      expect(build(:image, owner: product, name: 'same')).to have(1).error_on(:name)
    end

    it 'should not be allowed to create images with the same url' do
      create(:image, owner: product, url: 'same')
      expect(build(:image, owner: product2, url: 'same')).to have(1).error_on(:url)
    end
  end
end

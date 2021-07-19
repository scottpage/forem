RSpec.shared_examples "a profile field" do
  let(:profile_field_class) { described_class.name.underscore }

  describe "validations" do
    describe "builtin validations" do
      subject { create(profile_field_class) }

      it { is_expected.to validate_presence_of(:label) }
      it { is_expected.to validate_uniqueness_of(:label).case_insensitive }
      it { is_expected.to validate_presence_of(:attribute_name) }

      Profile::STATIC_FIELDS.each do |column|
        it "does not allow #{column} as profile field attribute" do
          profile_field = ProfileField.create(label: "Test", attribute_name: column)
          expect(profile_field).not_to be_valid
        end
      end
    end
  end

  describe "callbacks" do
    it "automatically generates an attribute name" do
      field = create(profile_field_class, label: "Test? Test! 1")
      expect(field.attribute_name).to eq "test_test1"
    end
  end
end

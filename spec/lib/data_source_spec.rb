require './spec/spec_helper.rb'

describe DataSource do

  let(:fake_source){"http://somesource/a.json"}

  context 'When loading data' do

    before :each do
      expect(RestClient).to receive(:get).with(fake_source).and_return(test_data)
      @data_source = DataSource.new(fake_source)
    end

    it 'should save raw data coming from request' do
      expect(@data_source.source_url).to eql(fake_source)
      expect(@data_source.raw_data).to eql(test_data)
    end

    it 'should parse data into zipcodes' do
      expect(@data_source.zip_codes.count).to eql(4)
      expect(@data_source.zip_codes.first._id).to eql(10010)
      expect(@data_source.zip_codes.first.state).to eql("NY")
      expect(@data_source.zip_codes.first.city).to eql("New York")
      expect(@data_source.zip_codes.first.pop).to eql(10000)
    end

    it 'should parse data into states' do
      @data_source.load_states
      expect(@data_source.states.keys).to eql(["NY", "CA"])
      expect(@data_source.states["NY"].name).to eql("NY")
    end

    it 'should parse data into states with cities' do
      @data_source.load_states
      expect(@data_source.states["CA"].cities.count).to eql(2)
    end

    it 'should prepare states with total population' do
      @data_source.load_states
      expect(@data_source.states["CA"].population).to eql(45000000)
    end

    it 'should prepare states with average population' do
      @data_source.load_states
      expect(@data_source.states["CA"].average_population).to eql(22500000)
    end

    it 'should prepare states with cities' do
      @data_source.load_states
      expect(@data_source.states["CA"].cities.keys.count).to eql(2)
      expect(@data_source.states["CA"].cities["livermore"].name).to eql("Livermore")
      expect(@data_source.states["CA"].cities["livermore"].population).to eql(43000000)
      expect(@data_source.states["CA"].cities["mountain view"].population).to eql(2000000)
    end

  end

end

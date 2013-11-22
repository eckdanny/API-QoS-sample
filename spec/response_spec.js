var fs = require('fs')
  , path = require('path')
  , mocks_dir = path.resolve(__dirname, '..', 'mocks')
  , mocks_files = fs.readdirSync(mocks_dir)
  , mock
  ;

// Loop over cached responses
mocks_files.forEach(function validatePayload (file) {
  mock = JSON.parse(fs.readFileSync(path.resolve(mocks_dir, file), 'utf8'));

  // Run the tests
  describe('UPC: ' + file.replace('.json', ''), function() {

    var o = mock.upcDetails;

    it('should have upcDetails', function () {
      expect(o).toBeDefined();
    });

    it('should have positive statusData', function () {
      expect(o.statusData).toBeDefined();
      expect(o.statusData.ResponseCode).toBe('0');
    });

    it('should have a brandName', function () {
      expect(typeof o.brandName).toBe('string');
      expect(o.brandName.length).toBeTruthy();
    });

    it('should have a shortDesc', function () {
      expect(typeof o.shortDesc).toBe('string');
      expect(o.shortDesc.length).toBeTruthy();
    });

    it('should have a longDesc', function () {
      expect(typeof o.longDesc).toBe('string');
      expect(o.longDesc.length).toBeTruthy();
    });

    it('should have a set of products', function () {
      expect(o.propertyIsEnumerable('products')).toBe(true);
      expect(o.products.length).toBeTruthy();
    });

    describe('products', function() {
      o.products.forEach( function validateProduct (product) {

        it('should have a partNumber', function() {
          expect(typeof product.partNumber).toBe('string');
          expect(product.partNumber.length).toBeTruthy();
        });

        // @todo this should be MORE strict! (eg; expect(price).toMatch(/^\d+\.\d{2}/); )
        it('should have a price', function () {
          expect(typeof product.price).toBe('string');
          expect(product.price.length).toBeTruthy();
        });

        it('should have an imgUrls array', function () {
          expect(product.propertyIsEnumerable('imgUrls')).toBe(true);
          expect(product.imgUrls.length).toBeTruthy();
        })

      });
    });

    it('should have a set of variants', function () {
      expect(o.propertyIsEnumerable('variants')).toBe(true);
      expect(o.variants.length).toBeTruthy();
    });

    describe('variants', function() {
      o.variants.forEach( function validateVariant (variant) {

        it('should have a fitName', function() {
          expect(typeof variant.fitName).toBe('string');
          expect(variant.fitName.length).toBeTruthy();
        });

        // @todo this SHOULD be more strict but there is too much variance in the fitNames
        it('should have a required denim descriptors based on fitName', function () {
          if (variant.fitName.match(/^Men/)) {
            expect(variant.waistSize).toBeDefined();
            expect(variant.inseam).toBeDefined();
          } else {
            expect(variant.size).toBeDefined();
          }
        });

      });
    });

  });
});
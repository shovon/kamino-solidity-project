// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol";
import "../contracts/TokenFactory.sol";

contract TokenFactoryTest {

    TokenFactory f;
    CustomToken ct;
    function beforeAll () public {
        f = new TokenFactory();
        ct = CustomToken(f.createToken("Custom Token", "CT", 1000000000 * 10**18));
    }

    function testGlobalToken () public {
        Assert.equal(ct.name(), "Custom Token", "token name did not match");
        Assert.equal(ct.symbol(), "CT", "token symbol did not match");
    }

    function testSuperToken () public {
        CustomToken sut = CustomToken(f.createToken("Super Token", "SUT", 1000000000 * 10**18));

        Assert.equal(sut.name(), "Super Token", "token name did not match");
        Assert.equal(sut.symbol(), "SUT", "token symbol did not match");
    }

    function testFastFourierTransformToken () public {
        CustomToken fft = CustomToken(f.createToken("Fast Fourier Transform", "FFT", 1000000000 * 10**18));

        Assert.equal(fft.name(), "Fast Fourier Transform", "token name did not match");
        Assert.equal(fft.symbol(), "FFT", "token symbol did not match");
    }
}

module git.torproject.org/pluggable-transports/snowflake.git/v2

go 1.15

require (
	git.torproject.org/pluggable-transports/goptlib.git v1.3.0
	github.com/clarkduvall/hyperloglog v0.0.0-20171127014514-a0107a5d8004
	github.com/gorilla/websocket v1.5.0
	github.com/pion/ice/v2 v2.2.6
	github.com/pion/sdp/v3 v3.0.5
	github.com/pion/stun v0.3.5
	github.com/pion/webrtc/v3 v3.1.41
	github.com/prometheus/client_golang v1.10.0
	github.com/prometheus/client_model v0.2.0
	github.com/refraction-networking/utls v1.0.0
	github.com/smartystreets/goconvey v1.6.4
	github.com/stretchr/testify v1.7.1
	github.com/xtaci/kcp-go/v5 v5.6.1
	github.com/xtaci/smux v1.5.15
	gitlab.torproject.org/tpo/anti-censorship/geoip v0.0.0-20210928150955-7ce4b3d98d01
	golang.org/x/crypto v0.0.0-20220516162934-403b01795ae8
	golang.org/x/net v0.0.0-20220425223048-2871e0cb64e4
	google.golang.org/protobuf v1.26.0
)

replace github.com/pion/webrtc/v3 v3.1.41 => github.com/xiaokangwang/webrtc/v3 v3.0.0-20230118142924-be9162e2b526

replace github.com/pion/dtls/v2 v2.1.5 => github.com/xiaokangwang/dtls/v2 v2.0.0-20230118142434-16e5cc8ce01c

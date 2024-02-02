def test_service_is_running(host):
    service = host.service("ansible")
    assert service.is_running
    assert service.is_enabled

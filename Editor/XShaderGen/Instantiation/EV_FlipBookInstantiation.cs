using System.Collections.Generic;
using UnityEngine;
#if XRP_SHADER_INSTANTIATION_META
{
    "ClassName": "EV_FlipBookShader",
    "Name": "XRender/Environment/FlipBook",
    "OutputPath": "Assets/Res/Shader/SurfaceShaderLibrary/EV_FlipBook.shader",
    "MM": "EV_FlipBook",
    "SM": "SHADING_MODEL_STANDARD_PBR",
    "Owner": "QP4B",
    "Usage": "Environment",
    "Desc": "A Sample FlipBook Effect For VEG In Environment",
    "PMs": [],
    "Config": [
        "SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Option)",
        "SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Option)",
        "SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Option)",
        "SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Option)",
        "SetOptionAlphaCutoffEnable(ShaderOptionFlag.OptionalDisable)",
        "SetOptionZWrite(ShaderOptionFlag.OptionalEnable)",
        "SetOptionTransparentZWrite(ShaderOptionFlag.OptionalDisable)",
        "SetOptionRefraction(ShaderOptionFlag.OptionalDisable)",
        "SetSupportDotsInstancing(true)"
    ]
}
#endif

namespace UnityEditor.XRender.XShaderGen.Instantiation
{
    [SurfaceShaderInstantiationAttribute]
    public class EV_FlipBookShader : XSurfaceShader
    {
        public override string GetName() => "XRender/Environment/FlipBook";
        public override string GetOwner() => "QP4B";
        public override string GetDesc() => "A Sample FlipBook Effect For VEG In Environment";
        public override SurfaceShaderUsage GetUsage() => SurfaceShaderUsage.Environment;
        public override string GetGenerateShaderPath() => "Assets/Res/Shader/SurfaceShaderLibrary/EV_FlipBook.shader";
        protected override string GetMaterialModelName() => "EV_FlipBook";
        protected override string GetShadingModelName() => "SHADING_MODEL_STANDARD_PBR";
        protected override List<PluginModelDesc> InitPluginModelDescs() => new()
        {
            // new PluginModelDesc {name = "DefaultPluginModel", needMultiCompile = false},
        };
        protected override void AdditionalConfig(SurfaceShaderConfig config)
        {
            config.SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Option);
            config.SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Option);
            config.SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Option);
            config.SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Option);
            config.SetOptionAlphaCutoffEnable(ShaderOptionFlag.OptionalDisable);
            config.SetOptionZWrite(ShaderOptionFlag.OptionalEnable);
            config.SetOptionTransparentZWrite(ShaderOptionFlag.OptionalDisable);
            config.SetOptionRefraction(ShaderOptionFlag.OptionalDisable);
            config.SetSupportDotsInstancing(true);
        }
    }
}
//ss:[[1848786133]]

